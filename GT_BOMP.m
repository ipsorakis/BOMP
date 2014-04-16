function Pframes = GT_BOMP(Bframes,Xframes,alpha_prior,beta_prior,changepoint_awareness)

if nargin<4
    alpha_prior = 2;
    beta_prior = 10;
end

if nargin<5
    changepoint_awareness = 5;
end

N = size(Xframes,1);
T = length(Bframes);

Pframes = cell(T,1);
ACTIVE = cell(T,1);

ALPHAS = alpha_prior*ones(N);
BETAS = beta_prior*ones(N);

T_RECENT = ones(N);


for t=1:T
    t
    P = zeros(N);
    B = 1*logical(Bframes{t});
    if isempty(B)
        Pframes{t} = sparse(P);
        continue
    end
    
    ACTIVE{t} = find(Xframes(:,t));
    node_pairs = combnk(ACTIVE{t},2);
    
    for m=1:size(node_pairs,1)
        x = node_pairs(m,1);
        y = node_pairs(m,2);
        
        bx = B(:,x);
        by = B(:,y);
        
        opportunities = sum(or(bx,by));
        
        w = dot(bx,by);
        
        
        dt = rescale(t - T_RECENT(x,y),1,T-1,0,10);
        kappa = 1/(1+exp(-changepoint_awareness*dt));        
        
        ALPHAS(x,y) = (1-kappa)*ALPHAS(x,y) + kappa*w;
        BETAS(x,y) = (1-kappa)*BETAS(x,y) + kappa*(opportunities - w);
        
        P(x,y) = ALPHAS(x,y)/(ALPHAS(x,y)+BETAS(x,y));
        
        T_RECENT(x,y) = t;
    end
    
    Pframes{t} = sparse(P);
end


end