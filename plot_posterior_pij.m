function P = plot_posterior_pij(i,j,BETA,tmax)
x = 0:.01:1;
[a b] = BETA.get_a_b_vectors(i,j);

if nargin<4
    T = length(a);
else
    T = tmax;
end

Xaxis_size = length(x);
Yaxis_size = T;

X = repmat(x',1,Yaxis_size);
Y = repmat(1:T,Xaxis_size,1);

P = zeros(Xaxis_size,T);

for t=1:T
    p = betapdf(x,a(t),b(t));
    P(:,t) = p;
    %vline(a(t)/(a(t)+b(t)),'k',num2str(t))
end

%figure
%surf(X,Y,P)

figure
imagesc(1:100,0:1,P)
end