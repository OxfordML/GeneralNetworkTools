function [Modularities_per_sample VD_errors] = sample_random_graph(number_of_samplings,max_steps,p,method,datafile,output_filename)
%% INITIALIZE
close all;
load(datafile);

if exist('groups','var')
    %VD_errors = zeros(number_of_samplings,length(groups));
    Ierrors = zeros(1,number_of_samplings);
end

N = size(W,1);
%% DO A RUN WITH FULL GRAPH
disp('--------RUNNING WITH FULL GRAPH---------------')
if strcmp(method,'eo')
    [current_groups current_mod best_iteration best_group] = extremal_optimization(W,max_steps,true,false);
    current_mod(end)=[];
elseif strcmp(method,'ng')
    [current_groups current_mod best_iteration best_group] = newman_girvan(W,max_steps,true,false);
elseif strcmp(method,'sp')
    [current_groups current_mod best_iteration best_group] = spectral_partitioning(W,max_steps,true,false);
elseif strcmp(method,'donetti_munoz')
    % DONETTI MUNOZ
    [current_groups current_mod best_iteration best_group] = donetti_munoz(W,max_steps,false,'complete-linkage',ceil(N/4),'angular');
elseif strcmp(method,'capocci')
    % CAPOCCI
    [current_groups current_mod best_iteration best_group] = hierachical_clustering(W,max_steps,false,'complete-linkage',...
        'capocci');
elseif strcmp(method,'hierarchical')
    % HIERARCHICAL CLUSTERING USING PEARSON SIMILARITY
    [current_groups current_mod best_iteration best_group] = hierachical_clustering(W,max_steps,false,'complete-linkage',...
        'pearson');
end

Q_full = current_mod
max_steps = max(size(current_mod));
Modularities_per_sample = zeros(number_of_samplings,max_steps);

if exist('groups','var')
    Ierror_full = get_normalized_mutual_information(groups,best_group);
end
disp('-----------------------------')
%% SAMPLE
disp('--------BEGINING SAMPLING---------------')
for sample=1:number_of_samplings
    sample
    
    Ws = sample_weight_matrix(W,p);
    
    if strcmp(method,'eo')
        % EXTREMAL OPTIMIZATION
        [current_groups current_mod best_iteration best_group] = extremal_optimization(Ws,max_steps,true,false);
        current_mod(end)=[];
    elseif strcmp(method,'ng')
        % NEWMAN GIRVAN
        [current_groups current_mod best_iteration best_group] = newman_girvan(Ws,max_steps,true,false);
    elseif strcmp(method,'sp')
        % SPECTRAL PARTITIONING
        [current_groups current_mod best_iteration best_group] = spectral_partitioning(Ws,max_steps,true,false);
    elseif strcmp(method,'donetti_munoz')
        % DONETTI MUNOZ
        [current_groups current_mod best_iteration best_group] = donetti_munoz(Ws,max_steps,false,'complete-linkage',ceil(N/4),'angular');
    elseif strcmp(method,'capocci')
        % CAPOCCI
        [current_groups current_mod best_iteration best_group] = hierachical_clustering(Ws,max_steps,false,'complete-linkage',...
            'capocci');
    elseif strcmp(method,'hierarchical')
        % HIERARCHICAL CLUSTERING USING PEARSON SIMILARITY
        [current_groups current_mod best_iteration best_group] = hierachical_clustering(Ws,max_steps,false,'complete-linkage',...
            'pearson');
        
    end
    
    Modularities_per_sample(sample,:) = current_mod;
    
    current_mod
    
    if exist('groups','var')
        %[C d VD_error] = partitioning_error(groups,best_group);
        %VD_errors(sample,:)=VD_error';
        Ierrors(sample) = get_normalized_mutual_information(groups,best_group);
    end
    disp('-----------------------------')
end
% if exist('groups','var')
%     mean_VD_errors = mean(VD_error);
% end

%% DO SOME PLOTTING
meanplot = mean(Modularities_per_sample,1);
stdplot = std(Modularities_per_sample,1);

hold on
myfig = errorbar(meanplot,stdplot);
plot(Q_full,'--r','LineWidth',2)
hline(get_modularity(groups,W),'g','observed Q');
title(strcat('Modularity across algorithm steps, ',method,', p=',num2str(p),', dataset=',datafile));
ylabel('Modularity Q');
xlabel('Algorithm steps (dendogram layers)');
legend(strcat(num2str(number_of_samplings),' samples'),'full graph');
hold off

%% SAVE IF NEEDED
if exist('output_filename','var')
    clear current_groups;
    save(strcat(output_filename,'_p',num2str(p*100),'_',method));
    saveas(myfig,strcat(output_filename,'_p',num2str(p*100),'_',method));
end
end