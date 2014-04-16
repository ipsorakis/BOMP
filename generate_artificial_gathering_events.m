N = 5;
K = 4;

T = 100;


lambda1 = T;
lambda_broker = 5;
lambda2 = 0.1;
Bframes = cell(T,1);

t_changepoint = 10;

for t=1:t_changepoint
    B = zeros(N,K);
    
    B(1:2,1:2) = poissrnd(lambda1,2);
    
    B(3,:) = poissrnd(lambda_broker,1,K);
%     B(3,5:end) = poissrnd(lambda_broker,1,N);
%     B(1,5) = lambda_broker;
%     B(2,6) = lambda_broker;
%     B(4,8) = lambda_broker;
%     B(5,9) = lambda_broker;
    
    B(4:5,3:4) = poissrnd(lambda1,2);
    
    Bframes{t} = B';
end

for t=t_changepoint+1:T
    B = zeros(N,K);
    
    lambda1 = lambda1 / 4;
    lambda2 = lambda2 * 4;

        B(3,:) = poissrnd(lambda_broker,1,K);
%     B(3,5:end) = poissrnd(lambda_broker,1,N);
%     B(1,5) = lambda_broker;
%     B(2,6) = lambda_broker;
%     B(4,8) = lambda_broker;
%     B(5,9) = lambda_broker;
    
    B(1:2,1) = poissrnd(lambda1,2,1);
    B(4:5,4) = poissrnd(lambda1,2,1);
    
    B([1 4],2) = poissrnd(lambda2,2,1);
    B([2 5],3) = poissrnd(lambda2,2,1);
    
    Bframes{t} = B';
end