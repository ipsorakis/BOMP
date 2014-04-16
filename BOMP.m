function [BETA, Wframes] = BOMP(Bframes,kappa)

% if nargin == 1
%     opportunity_function = @min;
% end

if ~exist('kappa','var')
    kappa = ones(2,1);
end

N = size(Bframes{1},2);

T = length(Bframes);

Wframes = cell(T,1);
BETA = beta_distribution_manager(N,T);

for t=1:T
    t
    A_prior = BETA.get_full_A;
    B_prior = BETA.get_full_B;
    
    B = full(Bframes{t});
        
    Opportunity_matrix = get_opportunity_matrix2(B);
    
    %W = get_coocurences_in_bipartite_graph(B);
    W = B'*B;
    
    A_post = ...
        kappa(1)*A_prior + kappa(2)*W;
    
    B_post = ...
        kappa(1)*B_prior + kappa(2)*(Opportunity_matrix - W);
    
    BETA.update_coefficients(A_post,B_post);
    
     Wframes{t} = W;
end

end