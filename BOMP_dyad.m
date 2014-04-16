function [p_exp,a,b,w] = BOMP_dyad(Bframes,x,y,kappa)

if nargin<4
    kappa = ones(2,1);
end

T = length(Bframes);

w = zeros(T+1,1);

a = zeros(T+1,1);
a(1) = 10;

b = zeros(T+1,1);
b(1) = 10;

t_last_obs = 1;

for t=1:T
    B = 1*logical(Bframes{t});
    if isempty(B),continue,end
    bx = B(:,x);
    by = B(:,y);
    
    opportunities = sum(or(bx,by));
    
    if opportunities==0
        a(t+1)=nan;
        b(t+1)=nan;
        w(t+1)=nan;
        continue;
    end
    
    w(t+1) = dot(bx,by);
    
    
    a(t+1) = kappa(1)*a(t_last_obs) + kappa(2)*w(t+1);
    b(t+1) = kappa(1)*b(t_last_obs) + opportunities - kappa(2)*w(t+1);
    
    t_last_obs = t+1;
end

a(1)=[];
b(1)=[];
w(1)=[];

p_exp = a./(a+b);
end