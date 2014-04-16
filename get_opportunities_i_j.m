function opp = get_opportunities_i_j(Xframes,i,j)
T = length(Xframes);
opp = zeros(T,1);
for t=1:T
   opp(t) = Xframes{t}(i,j); 
end

end