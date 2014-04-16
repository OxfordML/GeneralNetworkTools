function g = convert_soft_membership_matrix_to_groups(P)

P = P';

[K N] = size(P);

B = zeros(K,N);
for i=1:N
    max_index = find(P(:,i) == max(P(:,i)),1);
    B(max_index,i) = 1;
end

B = B';

empty_communities = sum(B)==0;

B(:,empty_communities) = [];

g = incidence_matrix_to_groups(B);

end