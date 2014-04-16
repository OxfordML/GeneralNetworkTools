%function [dendogram Qmonitor best_iteration best_group Iab] =
%extremal_optimization(W,max_steps,full_clustering_flag,plot_flag,division_threshold,observed_groups)
function [dendogram Qmonitor best_iteration best_group Iab] = extremal_optimization(W,max_steps,full_clustering_flag,plot_flag,division_threshold,observed_groups)

if ~exist('full_clustering_flag','var')
    full_clustering_flag=true;
end

if ~exist('plot_flag','var')
    plot_flag=true;
end

if ~exist('division_threshold','var')
   division_threshold = 1; 
end

Qthreshold = .1;

N = size(W,1);

if max_steps <2
    max_steps= ceil(log2(N));
end

Qmonitor = nan*ones(1,max_steps);

dendogram = cell(max_steps,1);

for current_step=1:max_steps
    if current_step==1
        aleaf = dendogram_leaf([],1:N);
        dendogram{current_step} = {aleaf};
        
        Qmonitor(current_step) = 0;
    else
        new_leaves = 0;
        current_layer = cell(new_leaves);
        for parent_leaf_index=1:length(dendogram{current_step-1})
            parent_leaf = dendogram{current_step-1}{parent_leaf_index};
            
            if length(parent_leaf.group) > division_threshold
                [group1 group2 Qcurr] = extremal_optimization_split(parent_leaf.group,W);
                
                if full_clustering_flag
                    if ~isempty(group1)
                        new_leaves = new_leaves +1;
                        leaf1 = dendogram_leaf(parent_leaf,group1);
                        current_layer{new_leaves} = leaf1;
                    end
                    
                    if ~isempty(group2)
                        new_leaves = new_leaves + 1;
                        leaf2 = dendogram_leaf(parent_leaf,group2);
                        current_layer{new_leaves} = leaf2;
                    end
                elseif Qcurr>Qthreshold
                    aleaf = dendogram_leaf(parent_leaf,parent_leaf.group);
                    new_leaves = new_leaves +1;
                    current_layer{new_leaves} = aleaf;
                end
            else
                aleaf = dendogram_leaf(parent_leaf,parent_leaf.group);
                new_leaves = new_leaves +1;
                current_layer{new_leaves} = aleaf;
            end
        end
        
        dendogram{current_step} = current_layer;
        current_partition = get_groups(current_layer);
        Qmonitor(current_step) = get_modularity(current_partition,W);
        
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
    end
end

best_iteration = find(Qmonitor==max(Qmonitor),1);
best_group = get_groups(dendogram{best_iteration});

if exist('observed_groups','var')
    Iab = get_normalized_mutual_information(observed_groups,best_group);
end

end
%% GET GROUPS
function groups = get_groups(current_layer)
g = length(current_layer);
groups = cell(g,1);
for i=1:g
    aleaf = current_layer{i};
    groups{i} = aleaf.group;
end
end
%% APPLY EXTREMAL OPTIMIZATION GIVEN A SUBGRAPH
function [max_group1 max_group2 Qmax] = extremal_optimization_split(parent_group,W)
%A = W>0;
Nt = length(parent_group);
N = size(W,1);
Qmax = -1*inf;

total_edges = sum(sum(triu(W(parent_group,parent_group))));

indices = parent_group(randperm(Nt));

e = zeros(2);

group1 = sort(indices(1:ceil(Nt/2)));
group2 = sort(indices(ceil(Nt/2)+1:Nt));

while true
    e(1,1) = sum(sum((W(group1,group1))))/2;
    e(2,2) = sum(sum((W(group2,group2))))/2;
    e(1,2) = sum(sum(W(group1,group2)));
    e(2,1) = e(1,2);
    e(isnan(e))=0;
    e=e./total_edges;
    
    a = sum(e,2);
    
    aux_indices_group1 = 1:length(group1);
    aux_indices_group2 = length(group1)+1:length(parent_group);
    
    Qcurrent=get_modularity2({aux_indices_group1 aux_indices_group2},W([group1 group2],[group1 group2]));
    
    if isnan(Qcurrent)
        Qcurrent=0;
    end
    %Qcurrent = sum(diag(e)-a.^2);
    %Qlamda = (total_edges/2)*sum(lamdas.*degree(A(indices,indices)));
    
    try
        if Qcurrent>Qmax
            Qmax=Qcurrent;
            max_group1 = group1;
            max_group2 = group2;
            converge_countdown = N;
        else
            converge_countdown=converge_countdown-1;
        end
        
        if converge_countdown==0
            break;
        end
    catch ME
        ME.stack;
    end;
    
    % TO VECTORISE
    lamdas = zeros(Nt,1);
    try
        for index_iterator =1:length(indices)
            if isempty(group2(group2==indices(index_iterator)))
                lamdas(index_iterator) = sum(W(indices(index_iterator),group1))...
                    /sum(W(indices(index_iterator),parent_group))...
                    - a(1);
            else
                lamdas(index_iterator) = sum(W(indices(index_iterator),group2))...
                    /sum(W(indices(index_iterator),parent_group))...
                    - a(2);
            end
        end
    catch ME
        ME.stack;
    end
    
    lamdas(isnan(lamdas))=0;
    
    [worst_node_indices worst_nodes] = find_minimums(indices,lamdas,ceil(length(indices)));
    worst_selector = ceil(abs(2.5*randn(1)));
    if worst_selector>length(worst_node_indices)
        worst_selector = length(worst_node_indices);
    end
    worst_fit = worst_node_indices(worst_selector);
    
    if ~isempty(group1(group1==worst_fit))
        group1(group1==worst_fit)=[];
        group2 = sort([group2 worst_fit]);
    else
        group2(group2==worst_fit)=[];
        group1 = sort([group1 worst_fit]);
    end
end
end