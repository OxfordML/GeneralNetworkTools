function [Groups Qmonitor best_iteration best_group Iab] = hierachical_clustering(W,max_steps,plot_flag,group_closeness,...
    similarity_measure,similarity_parameter1,similarity_parameter2,observed_groups)
%% INITIALIZATION
N = size(W,1);
Nprevious = N;

if ~exist('group_closeness','var')
    group_closeness = 'complete-linkage';
end

if ~exist('similarity_parameter1','var')
    S=node_similarity(W,similarity_measure);
else
   S=node_similarity(W,similarity_measure,similarity_parameter1,similarity_parameter2); 
end

Saux = S;

Groups = cell(1,max_steps);
Groups{1} = num2cell( (1:N)' );
Qmonitor = nan*ones(1,max_steps);
Qmonitor(1)=0;
%% MAIN ENGINE
for layer = 2:max_steps
    %% GROUP
    Nstep = ceil(Nprevious/2);
    current_partition = cell(Nstep,1);
        
    assigned = zeros(length(Groups{layer-1}),1);
    
    partition_index=0;
    while prod(assigned)==0
        partition_index = partition_index+1;
        [x y foundmax] = find_matrix_max(Saux);
        if ~isinf(foundmax)
            Saux(x,:)=-inf;
            Saux(:,x)=-inf;
            Saux(:,y)=-inf;
            Saux(y,:)=-inf;
            assigned(x)=1;
            assigned(y)=1;
            
            current_partition{partition_index,1} = [Groups{layer-1}{x} Groups{layer-1}{y}];
        else
            nextelem = find(assigned==0,1);
            assigned(nextelem)=1;
            current_partition{partition_index,1} = Groups{layer-1}{nextelem};
        end
    end
 
    Groups{layer} = current_partition;
    Saux = get_group_similarity(current_partition,S,group_closeness,W);
    if length(current_partition)~=1
        Qmonitor(layer) = get_modularity(current_partition,W);
    else
        Qmonitor(layer)=0;
    end
    %% PLOT
    if plot_flag
        figure(1)
        plot(Qmonitor)
        title('Modularity Q');
        drawnow;
        
        figure(2)
        community_graph(current_partition,W)
        title('Community Graph');
        drawnow;
        
        figure(3)
        clf
        group_indices=cat(2,current_partition{:});
        imagesc(W(group_indices,group_indices));
        title('W colormap');
        drawnow;
    end
    %% Finalize
    Nprevious = Nstep;
    if length(current_partition)==1
        Qmonitor = Qmonitor(1:layer);
        break;
    end
end

%% Find best partition
best_iteration = find(Qmonitor==max(Qmonitor));
best_group = Groups{best_iteration};

if exist('observed_groups','var')
   Iab = get_normalized_mutual_information(observed_groups,best_group); 
end
end