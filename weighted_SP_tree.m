% part of NEWMAN GIRVAN algorithm
function SP = weighted_SP_tree(A,distances,weights,startnode)
N = size(A,1);
SP = zeros(N);

for i=1:N
   if i~=startnode
      
      adjacency_set = find(A(i,:));
      adjacent_distances = A(i,:).*distances;

      adjacent_distances(adjacent_distances==0)=inf;
      if sum(ismember(adjacency_set,startnode))
          adjacent_distances(startnode)=0;
      end
      
      parent_nodes = find(adjacent_distances==distances(i)-1);
%       
%       adjacent_distances(adjacent_distances>distances(i))=inf;
%       parent_nodes = find(~isinf(adjacent_distances));
      
      SP(i,parent_nodes) = 1;
   end
end

end