function [W X Wnull_mean Wnull_std Pexp Pmode A_post B_post recorded_nodes] = build_weights_matrix_using_mixture_model_prototype(DATA,total_individuals,do_significance_test,A_prior,B_prior)

total_locations = max(DATA(:,3));

W = zeros(total_individuals);

Wnull_mean = zeros(total_individuals);
Wnull_std = zeros(total_individuals);

Pexp = zeros(total_individuals);
Pmode = zeros(total_individuals);

X = histc(DATA(:,2),1:total_individuals);

recorded_node_indices = unique(DATA(:,2));

recorded_nodes = false(total_individuals,1);
recorded_nodes(recorded_node_indices) = true;

if sum(1*recorded_nodes)<=1
    A_post = A_prior;
    B_post = B_prior;
    return
end


Opportunity_matrix = get_Opportunity_matrix(X);

%IM = index_manager(DATA(:,2));

for location_index = 1: total_locations
    DATA_local_worker_copy = DATA;
    location_indices = DATA_local_worker_copy(:,3) == location_index;
    if sum(location_indices) == 0
        continue;
    end
    
    if length(unique(DATA_local_worker_copy(location_indices,2)))<2
        continue;
    end
    
    DATA_LOC = DATA_local_worker_copy(location_indices,:);
    
    %     X_LOC = histc(DATA_LOC(:,2),1:total_individuals);
    %     Opportunity_matrix_LOC = get_Opportunity_matrix(X_LOC);
    %     Opportunity_matrix = Opportunity_matrix + Opportunity_matrix_LOC;
    
    [output gmm IM_LOC] = infer_graph_from_datastream_mmVB(DATA_LOC);
    W_LOC = output.W_hard_cooccurences;
    B_LOC = output.B_hard_incidence_matrix;
    
    %% DO SIGNIFICANCE TEST HERE
    % use either:
    if do_significance_test
        [W_NULL_LOC_MEAN W_NULL_LOC_STD P_VALUES_LOC] = do_significance_test_of_adjancency_given_indidence_matrix(W_LOC,B_LOC,.05,10000);
    end
    % or:
    %do_significance_test_based_on_square_distances(W_LOC,B_LOC,1000);
    %W_LOC_s = W_LOC;
    
    %%
    W_LOC(isnan(W_LOC)) = 0;
    W(IM_LOC.original_indices,IM_LOC.original_indices) = W(IM_LOC.original_indices,IM_LOC.original_indices) + W_LOC; % or W_LOC_s
    
    if do_significance_test
        W_NULL_LOC_MEAN(isnan(W_NULL_LOC_MEAN)) = 0;
        W_NULL_LOC_STD(isnan(W_NULL_LOC_STD)) = 0;
        Wnull_mean(IM_LOC.original_indices,IM_LOC.original_indices) = Wnull_mean(IM_LOC.original_indices,IM_LOC.original_indices) + W_NULL_LOC_MEAN;
        Wnull_std(IM_LOC.original_indices,IM_LOC.original_indices) = Wnull_std(IM_LOC.original_indices,IM_LOC.original_indices) + W_NULL_LOC_STD.^2;
    end
end

if do_significance_test
    Wnull_std = sqrt(Wnull_std);
end

%active_links = W~=0;
%active_nodes = sum(W)~=0;
%number_of_active_nodes = length(unique(DATA(:,2)));

% assume A_prior, B_prior
if nargin<=2
    A_prior = ones(total_individuals);
    B_prior = ones(total_individuals);
end

A_post = ...
    (A_prior + W);%.*active_links;

B_post = ...
    (B_prior + Opportunity_matrix - W);%;.*active_links;

% MEAN
Pexp = (A_post...
    ./ (A_post + B_post));%.*active_links;
Pexp(isnan(Pexp)) = 0;

% MODE
% A_post_aux = A_post(active_links);
% B_post_aux = B_post(active_links);
ONES = ones(total_individuals);
Pmode = ((A_post - ONES)...
    ./ (A_post + B_post - 2*ONES));%.*active_links;
Pmode(isnan(Pmode)) = 0;
end