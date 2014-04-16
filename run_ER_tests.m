iterations = 100;

Ps = .05:.05:.95;
pL = length(Ps);

Q_NMF = zeros(iterations,pL);
Q_LV = zeros(iterations,pL);
Q_SP = zeros(iterations,pL);
Q_EO = zeros(iterations,pL);


for p_index = 1:pL
    p = Ps(p_index);
    
    for i = 1:iterations
        
        fprintf('p: %.2f, interation: %d\n',Ps(p_index),i);
        
        A = get_ER_graph(100,p);
        
        groupsNMF = run_commDetNMF(A,size(A,1));
        Q_NMF(i,p_index) = get_modularity(groupsNMF,A);
        
        LV = cluster_jl(A,1);
        Q_LV(i,p_index) = max(LV.MOD);
        
        [dendogram Qmonitor iteration groupsSP] = spectral_partitioning(A,10,1,0);
        Q_SP(i,p_index) = Qmonitor(iteration);
        
        [dendogram Qmonitor iteration groupsEO] = extremal_optimization(A,10,1,0);
        Q_EO(i,p_index) = Qmonitor(iteration);
    end
end

% hold on
% 
% errorbar(mean(Q_NMF),std(Q_NMF),'-b','LineWidth',2)
% 
% errorbar(mean(Q_EO),std(Q_EO),'-r','LineWidth',2)
% 
% errorbar(mean(Q_LV),std(Q_LV),'-g','LineWidth',2)
% 
% errorbar(mean(Q_SP),std(Q_SP),'-m','LineWidth',2)
% 
% legend('NMF','EO','Louvain','Spectral');
% hold off

save('ER_modularity_comparisons_LARGE');