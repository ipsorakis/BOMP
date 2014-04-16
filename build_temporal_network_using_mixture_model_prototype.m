function [output Xframes BETA IM_nodes IM_locations] = ...
    build_temporal_network_using_mixture_model_prototype(DATA,do_significance_test,output_filename)

% rolling_window unit of measure = day
%
%% INITIALIZE
IM_nodes = index_manager(DATA(:,2));
DATA(:,2) = IM_nodes.get_relative_index(DATA(:,2));

IM_locations = index_manager(DATA(:,3));
DATA(:,3) = IM_locations.get_relative_index(DATA(:,3));

day_indices = get_day_indices(DATA);
% if ~exist('day_indices','var')
%     day_indices = get_day_indices(DATA);
% end
%
N = length(unique(DATA(:,2)));
% if ~exist('N','var')
%     N = length(unique(DATA(:,2)));
% end
%N = BIRDS_DATABASE.birds_number;

total_days = length(day_indices);

Wframes = cell(total_days,1);
Wframes_null_mean = cell(total_days,1);
Wframes_null_std = cell(total_days,1);

Xframes = zeros(N,total_days);

Pframes_exp = cell(total_days,1);
Pframes_mode = cell(total_days,1);

%BETA_a_frames = cell(total_days,1);
%BETA_b_frames = cell(total_days,1);
BETA = beta_distribution_manager(N,total_days);

for day_index=1:total_days
    fprintf('Day: %d out of %d\n',day_index,total_days);
    DATA_LOCAL = DATA;
    DATA_CHUNK = DATA_LOCAL(day_indices{day_index}(1):day_indices{day_index}(2),:);
    
    %     if day_index == 1
    %        A_prior = ones(N);
    %        B_prior = ones(N);
    %     else
    %        A_prior = BETA_a_frames{day_index-1};
    %        B_prior = BETA_b_frames{day_index-1};
    %     end
    A_prior = BETA.get_full_A;
    B_prior = BETA.get_full_B;
    
    [W X Wnull_mean Wnull_std Pexp Pmode A_post B_post recorded_nodes] = build_weights_matrix_using_mixture_model(DATA_CHUNK,N,do_significance_test,A_prior,B_prior);
    
    Wframes{day_index} = sparse(triu(W,1));
    Wframes_null_mean{day_index} = sparse(triu(Wnull_mean,1));
    Wframes_null_std{day_index} = sparse(triu(Wnull_std,1));
    
    Pframes_exp{day_index} = sparse(triu(Pexp,1));
    Pframes_mode{day_index} = sparse(triu(Pmode,1));
    
    %BETA_a_frames{day_index} = sparse(A_post);
    %BETA_b_frames{day_index} = sparse(B_post);
    BETA.update_coefficients(A_post,B_post,recorded_nodes);
    
    Xframes(:,day_index) = X;
end

if exist('output_filename','var')
    label = output_filename;
else
    label = 'none';
end

output = struct('Wframes',Wframes,'Wframes_null_mean',Wframes_null_mean,'Wframes_null_std',Wframes_null_std,...
    'Pframes_exp',Pframes_exp,'Pframes_mode',Pframes_mode,...
    'label',label,'do_significance_test',do_significance_test);

%% FINALIZE AND SAVE
if exist('output_filename','var')
    %keep output_filename DATA Wframes Xframes Wframes_null N day_indices total_days
    keep output;
    save(output.label);
end
end
