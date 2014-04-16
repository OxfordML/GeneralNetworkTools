function PopularEdges = get_edge_betweeness(W)
%% INITIALIZE
A = W>0;
N = size(A,1);
PopularEdges = zeros(N,N,N);
%% (RE)CALCULATE POPULARITIES GIVEN STEP
for startnode=1:N
    %startnode
    [distances weights] = weighted_shortest_paths(A,startnode);
    
    SP = weighted_SP_tree(A,distances,weights,startnode);
    PopularEdges(:,:,startnode) = edge_popularity_given_startnode(A,startnode,distances,weights,SP);
end

PopularEdges = sum(PopularEdges,3);
end