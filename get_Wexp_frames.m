function Wframes = get_Wexp_frames(Pframes,Bframes,Xframes)

T = length(Pframes);
Wframes = cell(T,1);
N = size(Bframes{1},2);

for t=1:T
    active = Xframes(t,:)~=0;
    
    if sum(active)==0
        continue
    end
    
    B = full(Bframes{t});
    
    if isempty(B)
        continue
    end
    
    P = decompress_adjacency_matrix(Pframes{t});
    P = P(active,active);
    
    
    B = B(:,active);
    
    OPPORTUNITIES = get_opportunity_matrix2(B);
    
    W = zeros(N);
    W(active,active) = OPPORTUNITIES .* P;
    Wframes{t} = compress_adjacency_matrix(W);
end

end