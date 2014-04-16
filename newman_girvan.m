function [dendogram Qmonitor best_iteration best_group Iab] = newman_girvan(W,max_steps,full_clustering_flag,plot_flag,observed_groups)

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
                [group1 group2 Qcurr] = newman_girvan_split(W,parent_leaf.group);
                
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

%% OLD IMPLEMENTATION
% %profile on
% close all;
% 
% A = W>0;
% N = size(A,1);
% 
% if ~exist('plot_flag','var')
%     plot_flag=true;
% end
% 
% if ~exist('max_steps','var')
%     max_steps = floor(log(N));
% end
% 
% if ~exist('full_clustering_flag','var')
%     full_clustering_flag=true;
% end
% 
% Groups = cell(max_steps,2^(max_steps-1));
% %Modularities = zeros(max_steps,2^(max_steps-1));
% 
% Qmonitor = nan*ones(1,max_steps);
% 
% for current_step=1:max_steps
%     for partition_index=1:2:2^(current_step-1)
%         if current_step==1
%             Groups{current_step,1} = 1:N;
%             %Modularities(current_step,1)=0;
%             break;
%         elseif length(Groups{current_step-1,ceil(partition_index/2)})==1
%             Groups{current_step,partition_index} = Groups{current_step-1,ceil(partition_index/2)};
%             Groups{current_step,partition_index+1} = [];
%             
%             %Modularities(current_step,partition_index)=0;
%             %Modularities(current_step,partition_index+1)=0;
%         elseif ~isempty(Groups{current_step-1,ceil(partition_index/2)})
%             if full_clustering_flag
%                 [Groups{current_step,partition_index} Groups{current_step,partition_index+1}]...
%                     = newman_girvan_split(W(Groups{current_step-1,ceil(partition_index/2)},Groups{current_step-1,ceil(partition_index/2)}),...
%                     Groups{current_step-1,ceil(partition_index/2)});
%             else
%                 [group1 group2]...
%                     = newman_girvan_split(W(Groups{current_step-1,ceil(partition_index/2)},Groups{current_step-1,ceil(partition_index/2)}),...
%                     Groups{current_step-1,ceil(partition_index/2)});
%                 if modularity>0
%                     Groups{current_step,partition_index}=group1;
%                     Groups{current_step,partition_index+1}=group2;
%                 else
%                     Groups{current_step,partition_index}=Groups{current_step-1,ceil(partition_index/2)};
%                     Groups{current_step,partition_index+1}=[];
%                 end
%             end
%             %             [Groups{current_step,partition_index} Groups{current_step,partition_index+1} Modularities(current_step,partition_index)]...
%             %                 = newman_girvan_split(A(Groups{current_step-1,ceil(partition_index/2)},Groups{current_step-1,ceil(partition_index/2)}),...
%             %                 Groups{current_step-1,ceil(partition_index/2)});
%             %
%             %Modularities(current_step,partition_index+1) = Modularities(current_step,partition_index);
%         end
%     end
%     
%     if current_step~=1
%         
%         current_partition = remove_empties(Groups(current_step,:));
%         Qmonitor(current_step) = get_modularity2(current_partition,W);
%         %Qmonitor(current_step) = get_q(Groups,current_step,W);
%         
%         if plot_flag
%             figure(1)
%             plot(Qmonitor)
%             title('Modularity Q');
%             drawnow;
%             
%             figure(2)
%             community_graph(current_partition,W)
%             title('Community Graph');
%             drawnow;
%             
%             figure(3)
%             clf
%             group_indices=cat(2,current_partition{:});
%             imagesc(W(group_indices,group_indices));
%             title('W colormap');
%             drawnow;
%         end
%     else
%         Qmonitor(current_step)=0;
%     end
% end
% 
% best_iteration = find(Qmonitor==max(Qmonitor),1);
% best_group = remove_empties(Groups(best_iteration,:));
% if exist('observed_groups','var')
%    Iab = get_normalized_mutual_information(observed_groups,best_group); 
% end
% %toc
% % profile off
% % profile report
% end