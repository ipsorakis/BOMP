function [Pexp Pmode] = single_link_update(wij,xij,kappa)

if ~exist('kappa','var')
    kappa1 = 1;
    kappa2 = 1;
else
    kappa1 = kappa;
    kappa2 = 1-kappa;
end

N = 2;

T = length(wij);
Pexp = zeros(T,1);
Pmode = zeros(T,1);

P1 = zeros(T,1);
P2 = zeros(T,1);
LOGIT = zeros(T,1);

a_post = 100;
b_post = 100;

unknown = false(T,1);


for t=1:T
    
    if t==1
        P1(t) = .5;
    else
        P1(t) = binopdf(wij(t),Pexp(t-1),xij(t));
    end
    
    a_prior = a_post;
    b_prior = b_post;
    
    if isnan(wij(t))
        unknown(t) = true;
        continue;
    end
    
    a_post = kappa1*a_prior + kappa2*wij(t);
    b_post = kappa1*b_prior + kappa2*(xij(t) - wij(t));
    
    Pexp(t) = a_post / (a_post + b_post);
    Pmode(t) = (a_post - 1) / (a_post + b_post - 2);
    
    P2(t) = binopdf(wij(t),Pexp(t),xij(t));
    
    LOGIT(t) = log(P2(t)) - log(P1(t));
end

Pexp(unknown) = [];
Pmode(unknown) = [];

end