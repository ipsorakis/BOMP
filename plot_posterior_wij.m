function [w_post xij] = plot_posterior_wij(i,j,BETA,Bframes,Wframes,opportunity_function)


T = length(Wframes);

[a b] = BETA.get_a_b_vectors(i,j);

wij = zeros(T,1);
xij = zeros(T,1);

w_post = zeros(T,1);
%H = zeros(T,1);

%hold on
for t=1:T
    %
    wij(t) = full(Wframes{t}(i,j));
    
    %
    x = sum(full(Bframes{t}));
    xi = x(i);
    xj = x(j);
    
    
    if opportunity_function == 1
        xij(t) = min(xi,xj);
    else
        xij(t) = sum(1*or(Bframes{t}(:,i),Bframes{t}(:,j)));
    end
    
   
    k=0:xij(t);
    
    %p = betabinompdf(k,xij(t),a(t+1),b(t+1));
    
    w_post(t) = xij(t)*a(t+1)/(a(t+1)+b(t+1));
    %vline(p*xij(t));
    
    %H(t) = get_entropy(p');
    
    %pause
end
%hold off

hold on
plot(1:t,w_post);
scatter(1:t,wij,'r');
plot(xij,'k');
title(strcat('Observed versus expected link weight between nodes',num2str(i),'&',num2str(j)));
legend(strcat('E[w',num2str(i),num2str(j),']'),strcat('obs. w',num2str(i),num2str(j)),strcat('x',num2str(i),num2str(j)));
xlabel('time t');
hold off
end