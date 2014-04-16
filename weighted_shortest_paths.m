% part of NEWMAN GIRVAN algorithm
function [distances weights] = weighted_shortest_paths(A,startnode)

N = size(A,1);
%visited = boolean(0)*ones(1,N);

distances = inf*ones(1,N);
weights = zeros(1,N);

nodes = queue(N);

nodes.add(startnode);
distances(startnode)=0;
weights(startnode)=1;
%visited(startnode) = true;

search();

    function search()
        currentnode = nodes.remove();
        adjacency_set = find(A(currentnode,:));
        
        for i=1:length(adjacency_set)
            nextnode = adjacency_set(i);
            if isinf(distances(nextnode))
                distances(nextnode) = distances(currentnode)+1;
                weights(nextnode) = weights(currentnode);
            elseif distances(nextnode)==distances(currentnode)+1
                weights(nextnode)=weights(nextnode)+weights(currentnode);
            end
            
            %nodes.add(nextnode);
            next_adjacency_set = find(A(nextnode,:));
            if isinf(sum(distances(next_adjacency_set))) && ~nodes.exists(nextnode);
                nodes.add(nextnode);
            end
        end
        
        if nodes.isEmpty()
            return;
        else
            search();
        end
    end

end