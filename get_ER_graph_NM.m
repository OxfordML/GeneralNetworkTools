function A = get_ER_graph_NM(N,M)

A = zeros(N);

node_pairs = combnk(1:N,2);
number_of_stubs = size(node_pairs,1);
randomised_row_indices = randperm(number_of_stubs);

node_pairs = node_pairs(randomised_row_indices,:);

for m=1:M
    i = node_pairs(m,1);
    j = node_pairs(m,2);
    
    A(i,j) = 1;
    A(j,i) = 1;
end

end