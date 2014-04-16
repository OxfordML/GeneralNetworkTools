function [path] = broad_search(A,startnode,endnode)
N = size(A,1);
visited = boolean(0)*ones(1,N);
path = zeros(1,N);
nodes = queue(N);
found=false;

nodes.add(startnode);
visited(startnode) = true;
if startnode==endnode
    found = true;
else
    search();
end

disp('Path found:')
% path(find(path==0,1,'first'))=startnode
% path = path(path~=0)
path = path(length(path):-1:1)

    function search()
        currentnode = nodes.remove();
        adjacency_set = find(A(currentnode,:)>0);
        
        for i=1:length(adjacency_set)
            if ~visited(adjacency_set(i))
                visited(adjacency_set(i))=true;
                nodes.add(adjacency_set(i))
                if adjacency_set(i) == endnode
                    path(find(path==0,1,'first'))=adjacency_set(i);
                    found = true;
                    break;
                end
            end
        end
        
        if found==false
            search();
        else
            path(find(path==0,1,'first')) = currentnode;
        end
    end
end