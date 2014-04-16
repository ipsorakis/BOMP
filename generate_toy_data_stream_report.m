function Bframes = generate_toy_data_stream_report(T,lambda_in,lambda_br)

Bframes = cell(T,1);

B_baseline = [20 20 0 0 ; 20 20 0 0 ; 0 0 0 0 ; 0 0 20 20; 0 0 20 20];

%B_active = B_baseline~=0;

[N K] = size(B_baseline);

for t=1:T
    B = zeros(N,K);
    
    B([1 2],[1 2]) = B_baseline([1 2],[1 2]) + poissrnd(lambda_in,2,2);
    B([4 5],[3 4]) = B_baseline([4 5],[3 4]) + poissrnd(lambda_in,2,2);
    B(3,:) = B_baseline(3,:) + poissrnd(lambda_br,1,K);
    
    Bframes{t} = B';
end

end