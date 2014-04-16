function [path] = deep_search(A,startnode,endnode)

N = size(A,1);
visited = boolean(0)*ones(1,N);
nodes = stack(N);
found=false;

search(startnode);

disp('Path found:')
path = nodes.get();

    function search(currentnode)
        
        nodes.push(currentnode);
        %nodes.get()
        visited(currentnode) = true;
        
        if currentnode == endnode
            found=true;
            return;
        end
        
        adjacency_set = find(A(currentnode,:)==1);
        
        
        for i=1:length(adjacency_set)
            if ~visited(adjacency_set(i))
                search(adjacency_set(i));
                if found
                    return;
                end
            end
        end
        nodes.pop();
        %nodes.get()
        
    end


end