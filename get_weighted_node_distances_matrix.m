function D = get_weighted_node_distances_matrix(A)
N = size(A,1);
D = zeros(N);

for i=1:N
    D(:,i) = weighted_shortest_paths(A,i);
end

end