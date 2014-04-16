function Bframes = generate_boolean_incidence_matrices(Bfeeder,T,Bfeeder_c)

[K N] = size(Bfeeder);

if nargin<3
    Bframes = cell(T,1);
else
    Bframes = cell(2*T,1);
end

for t=1:T
    Bframes{t} =  binornd(ones(K,N),Bfeeder);
end

if nargin>2
    [K N] = size(Bfeeder);
    for t=T+1:2*T
        Bframes{t} =  binornd(ones(K,N),Bfeeder_c);
    end
end

end