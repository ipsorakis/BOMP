function Ps = plot_BOMP_pairs_against_baseline(Bframes,Pframes,ACTIVE,pairs)
T = length(Pframes);
total_pairs = size(pairs,1);
Pexp_baseline = get_Pexp_baseline(Pframes,ACTIVE);
Ps = zeros(T,total_pairs);
plot(Pexp_baseline,'--k','LineWidth',2)
for m=1:total_pairs
    x = pairs(m,1);
    y= pairs(m,2);
    Ps(:,m) = BOMP_dyad(Bframes,x,y);
end
hold
plot(Ps,'LineWidth',2)
end