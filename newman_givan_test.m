N = size(A,1);

[distances weights] = weighted_shortest_paths(A,startnode)
SP = weighted_SP_tree(A,distances,weights,startnode)
PopularEdges(:,:,startnode) = edge_popularity_given_startnode(A,startnode,distances,weights,SP)