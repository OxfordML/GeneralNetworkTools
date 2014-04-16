function output = knn_k(A,k)
degrees = degree(A,1:1:size(A,1));
nodes_k=find(degrees==k);

sum_knn=0;
for i=1:length(nodes_k)
    sum_knn = sum_knn + knn(A,nodes_k(i));
end
output = sum_knn/length(nodes_k);

end