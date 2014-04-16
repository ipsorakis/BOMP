function Bframes = generate_temporal_bipartite_sequence(A,T,Z,dt_in,dt_out,noise)

Bframes = cell(T,1);

parfor t=1:T    
   Zday = poissrnd(Z);    
   [~, Bframes{t}] = create_data_stream_given_graph_cliques(A,Zday,dt_in,dt_out,noise);
end

end