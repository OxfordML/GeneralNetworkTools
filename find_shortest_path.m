function [path distances] = find_shortest_path(A,startnode,endnode,distances)

if ~exist('distances','var')
    distances = geodesic_distances(A,startnode);
end

currentnode = endnode;
path = zeros(1,distances(endnode)+1);
path(length(path))=startnode;
path(1) = endnode;

while currentnode~=startnode
            adjacency_set = find(A(currentnode,:)>0);
            nextnode=adjacency_set(find(distances(adjacency_set)==min(distances(adjacency_set)),1,'first'));
            path(find(path==0,1,'first'))=nextnode;
            currentnode = nextnode;
end

path = path(length(path):-1:1);
end