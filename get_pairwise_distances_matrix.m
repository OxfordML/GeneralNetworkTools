function D = get_pairwise_distances_matrix(A)
N = size(A,1);
D = zeros(N);

for i=1:N
    D(:,i) = geodesic_distances(A,i);
end

end