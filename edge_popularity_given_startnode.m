% part of NEWMAN GIRVAN algorithm
function [EdgePop] = edge_popularity_given_startnode(A,startnode,distances,weights,SP)
N = size(A,1);
EdgePop = zeros(N);
current_level = max(distances);

while current_level ~=0
   
    current_level_nodes = find(distances==current_level);
    
    for i=1:length(current_level_nodes)
       current_node = current_level_nodes(i); 
       above_nodes = find(SP(current_node,:));
       
       for j=1:length(above_nodes)
           current_above_node = above_nodes(j);
           EdgePop(current_node,current_above_node) = (1 +  EdgePop(current_node,:)*SP(:,current_node) )...
               * weights(current_above_node)/weights(current_node);
           EdgePop(current_above_node,current_node) = EdgePop(current_node,current_above_node);
       end
    end
    
    current_level=current_level-1;
end

end