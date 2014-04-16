function Opportunity_matrix = get_opportunity_matrix2(B)

[K N] = size(B);

Opportunity_matrix = zeros(N);

for i=1:N-1
    for j=i+1:N
        Opportunity_matrix(i,j) = sum(1*or(B(:,i),B(:,j)));
    end
end

Opportunity_matrix = Opportunity_matrix + Opportunity_matrix';

end