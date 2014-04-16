function Pexp_baseline = get_Pexp_baseline(Pframes,ACTIVE)

T = length(Pframes);

Pexp_baseline = zeros(T,1);

for t=1:T
    node_pairs = combnk(ACTIVE{t},2);
    
    p_exp = zeros(size(node_pairs,1),1);
    for m=1:size(node_pairs,1)
        x = node_pairs(m,1);
        y = node_pairs(m,2);
        
        %aux = mating_pairs - [x y];
        
        p_exp(m) = Pframes{t}(x,y);
    end
    Pexp_baseline(t) = mean(p_exp);
end

end