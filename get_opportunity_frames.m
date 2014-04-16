function Xframes = get_opportunity_frames(Bframes)
T = length(Bframes);
Xframes = cell(T,1);
for t=1:T
   Xframes{t} = get_opportunity_matrix2(Bframes{t}); 
end
end