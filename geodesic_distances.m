function distances = geodesic_distances(A,startnode)
N = size(A,1);
visited = boolean(0)*ones(1,N);

distances = inf*ones(1,N);

nodes = queue(N);

nodes.add(startnode);
visited(startnode) = true;
search();

%disp('Graph traversed.')

    function search()
        currentnode = nodes.remove();
        adjacency_set = find(A(currentnode,:)>0);
        
        if currentnode == startnode
            distances(currentnode)=0;
        else
            distances(currentnode) = min(distances(adjacency_set))+1;
        end
        
        for i=1:length(adjacency_set)
            if ~visited(adjacency_set(i))
                visited(adjacency_set(i))=true;
                nodes.add(adjacency_set(i))
                %nodes.get()
            end
        end
        
        if nodes.isEmpty()
            return;
        else
            search();
        end
    end

end