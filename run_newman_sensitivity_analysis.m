%% INITIALIZE
output_directory = 'Reports/report-15-3-2010/sensitivity/';
methods = {'nmf','Spectral','Hierarchical','EO'};

K = 16;
Kout_max=K/2;

reruns=100;

Q_spectral = zeros(reruns,length(methods));
Q_EO = zeros(reruns,length(methods));
Q_nmf = zeros(reruns,length(methods));
Q_hier = zeros(reruns,length(methods));


I_spectral = zeros(reruns,length(methods));
I_EO = zeros(reruns,length(methods));
I_nmf = zeros(reruns,length(methods));
I_hier = zeros(reruns,length(methods));

%% RUN SENSITIVITY FOR VARIOUS Kout
for kout=1:Kout_max
    disp('========== RERUN ===============')
    disp(kout)
    for rerun_index=1:reruns
        [A groups] = get_newman_random_graph(K-kout);
        N = size(A,1);
        W=A;
        
        for method_index = 1:length(methods) 
            if strcmp(methods{method_index},'Spectral')
                %% SPECTRAL PARTITIONING
                [~, Qmonitor, best_iteration, best_group Iab] = spectral_partitioning(W,10,true,false,groups);
                
                Q_spectral(rerun_index,kout) = Qmonitor(best_iteration);
                I_spectral(rerun_index,kout) = Iab;
                
            elseif strcmp(methods{method_index},'EO')
                %% EXTREMAL OPTIMIZATION
                [~, Qmonitor, best_iteration, best_group Iab] = extremal_optimization(W,10,true,false,groups);
                Q_EO(rerun_index,kout) = Qmonitor(best_iteration);
                I_EO(rerun_index,kout) = Iab;
            elseif strcmp(methods{method_index},'nmf')
                %% NON-NEGATIVE MATRICES
                [best_group,Qbest,~,~,~,Iab] = cm_nmf(W,10,0,groups);
                Q_nmf(rerun_index,kout) = Qbest;
                I_nmf(rerun_index,kout) = Iab;
            elseif strcmp(methods{method_index},'Hierarchical')
                %% HIERARCHICAL CLUSTERING
                [~, Qmonitor, best_iteration, best_group, Iab] = hierachical_clustering(W,N,false,'complete-linkage','pearson',-1,-1,groups);
                Q_hier(rerun_index,kout) = Qmonitor(best_iteration);
                I_hier(rerun_index,kout) = Iab;
            end
        end
    end
    disp('-------------------')
end

save(strcat(output_directory,'sensitivity100reruns'))