function plot_P_exp_pairs_vs_baseline(Pframes,ACTIVE,pairs)

T = length(Pframes,1);
N = size(Pframes{1},1);

total_pairs = size(pairs,1);

Pexp_baseline = zeros(T,1);

Pexp_pairs = zeros(T,total_pairs);

for t=1:T
    node_pairs = combnk(ACTIVE{t},2);
    
    p_exp = zeros(size(node_pairs,1));
    for m=1:size(node_pairs,1)
        x = node_pairs(m,1);
        y = node_pairs(m,2);
        
        p_exp(m) = Pframes{t}(x,y);
    end
    Pexp_baseline(t) = mean(p_exp);
end

end