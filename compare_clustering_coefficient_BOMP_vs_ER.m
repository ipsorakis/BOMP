function p = compare_clustering_coefficient_BOMP_vs_ER(Pframes,ACTIVE)

T = length(ACTIVE);
number_of_randomisations = 1000;

for t=1:T
   Pt = decompress_adjacency_matrix(Pframes{t});
   Pt = Pt(ACTIVE{t},ACTIVE{t});
   
   N = size(Pt,1);
   M = sum(sum(Pt~=0))/2;
   
   [c C_obs] = get_clustering_coefficient(Pt);
   
   C_null = zeros(number_of_randomisations,1);
   parfor r=1:number_of_randomisations
       A = get_ER_graph_NM(N,M);
       [c_null C_null(r)] = get_clustering_coefficient(A);       
   end
   
   hist(C_null,0:.01:1);
   hold on
   vline(C_obs,'r');
   hold off
end

end