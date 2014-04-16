function opp = get_simple_cooccurrences_i_j(Aframes,i,j)
T = length(Aframes);
opp = zeros(T,1);
for t=1:T
   opp(t) = Aframes{t}(i,j); 
end

end