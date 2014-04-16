%[dendogram Qmonitor best_iteration best_group Iab] = spectral_partitioning(W,max_steps,full_clustering_flag,plot_flag,
% observed_groups,division_threshold)
function [dendogram Qmonitor best_iteration best_group Iab] = spectral_partitioning(W,max_steps,full_clustering_flag,plot_flag,...
    observed_groups,division_threshold)

N = size(W,1);

if ~exist('plot_flag','var')
    plot_flag=true;
end

if max_steps <2
    max_steps= ceil(log2(N));
end

if ~exist('full_clustering_flag','var')
    full_clustering_flag=true;
end


if ~exist('division_threshold','var')
   division_threshold = 1; 
end

Qthreshold = .1;

B = get_modularity_matrix(W);
total_strength = sum(sum(W))/2;

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
                [group1 group2 Qcurr] = spectral_split(B,total_strength,parent_leaf.group);
                
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
%% APPLY SPECTRAL PARTITIONING
function [group1 group2 DQ] = spectral_split(B,m,parent_group)
N = size(B,1);

if ~exist('parent_group','var')
    parent_group = 1:N;
    Ng = N;
else
    Ng = length(parent_group);
end

s = -1*ones(Ng,1);
Bg = B(parent_group,parent_group) - eye(Ng) .* repmat( get_strength(B(parent_group,parent_group)) , 1, Ng);

[V D] = eig(Bg);
beta = find(diag(D)==max(diag(D)));
u = V(:,beta)';

s(u>0) = 1;

DQ = (s' * Bg * s)/(4*m);

if DQ>0
   group1_indices = find(s==1);
   group1 = parent_group(group1_indices);
   
   group2_indices = find(s==-1);
   group2 = parent_group(group2_indices);
else
    group1 = parent_group;
    group2 = [];
end
end