function [path] = broad_traversal(A,startnode)
N = size(A,1);
visited = boolean(0)*ones(1,N);
path = zeros(1,N);
nodes = queue(N);

nodes.add(startnode);
visited(startnode) = true;
search();

disp('Graph traversed.')

    function search()
        currentnode = nodes.remove();
        nodes.get()
        adjacency_set = find(A(currentnode,:)>0);
        
        for i=1:length(adjacency_set)
            if ~visited(adjacency_set(i))
                visited(adjacency_set(i))=true;
                nodes.add(adjacency_set(i))
                nodes.get()
            end
        end
        
        if nodes.isEmpty()
            return;
        else
            search();
        end
    end
end