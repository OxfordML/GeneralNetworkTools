function [] = partition_sensitivity(A,method_flag,max_steps,parameter1,parameter2,dataset_name,removal_methodology)

%% STUDY BASED ON DEGREES
Aoriginal = A;
N = size(A,1);
if ~exist('removal_methodology','var')
    removal_methodology = 'random';
end

if strcmp(removal_methodology,'degree')
    degrees = degree(A);
    uniques = unique(degrees);
    
    modularities = zeros(length(uniques),max_steps);
    
    max_degree = max(uniques);
    min_degree = min(uniques);
    
    max_iterations = length(uniques);
elseif strcmp(removal_methodology,'random')
    max_iterations = N;
    elems = randperm(N);
    modularities = zeros(max_iterations,max_steps);
end
for d = 1:max_iterations
    
    if strcmp(removal_methodology,'degree')
        rem_elem = find(degrees==uniques(d),1);
        
        if uniques(d)==max_degree
            max_degree_run=d;
        elseif uniques(d)==min_degree
            min_degree_run=d;
        end
    else
        rem_elem = elems(d);
    end
    A(rem_elem,:)=0;
    A(:,rem_elem)=0;
    
    switch method_flag
        case 1
            method_name = 'E0';
            [Groups modularities(d,:)] = extremal_optimization(A,max_steps,parameter1,parameter2);
        case 2
            method_name = 'NG';
            [Groups modularities(d,:)] = newman_girvan(A,max_steps,parameter1,parameter2);
        case 3
            if ~exist('parameter1','var')
                parameter1='degree';
            end
            method_name = 'AP';
            [Groups modularities(d,:)] = affinity_propagation(A,A,max_steps,parameter1);
    end
    
    A = Aoriginal;
end

switch method_flag
    case 1
        [Groups modularities_full] = extremal_optimization(A,max_steps,parameter1,parameter2);
    case 2
        [Groups modularities_full] = newman_girvan(A,max_steps,parameter1,parameter2);
    case 3
        [Groups  modularities_full] = affinity_propagation(A,A,max_steps,parameter1);
end

std_modularities = std(modularities,1);
mean_modularities = mean(modularities,1);

if ~exist('dataset_name','var')
    dataset_name='dataset';
end

close all
hold on
errorbar(mean_modularities,std_modularities,'g');

plot(modularities_full,'-k','LineWidth',2)

if strcmp(removal_methodology,'degree')
    plot(modularities(max_degree_run,:),'--rs');
    plot(modularities(min_degree_run,:),'--bs');
end
title(strcat('Modularity-',method_name,' partitioning, dataset:',dataset_name,' methodology:',removal_methodology))

legend('multiple runs','full dataset','run without max','run without min')
hold off
end