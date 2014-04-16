function output = knn(A,node)
output = sum(degree(A,find(A(node,:)~=0)))/degree(A,node);
end