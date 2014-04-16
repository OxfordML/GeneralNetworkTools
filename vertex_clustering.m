function c = vertex_clustering(A,node)

N = size(A,1);
k = degree(A,node);

sum = 0;
for j=1:N
    for h=1:N
        sum = sum+A(node,j)*A(j,h)*A(node,h);
    end
end

c = sum/(k*(k-1));

end