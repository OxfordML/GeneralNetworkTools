function P = popular_paths(A)

N = size(A,1);
%Distances = zeros(N);
SPs = cell(N);
P = zeros(N);

for i=1:N
    %Distances(i,:) = shortest_paths(A,i);
    
    for j=1:N
       if i~=j
           SPs{i,j} = find_shortest_path(A,i,j);
       else
           SPs{i,j} = i;
       end
    end
end

for i=1:N
    for j=1:N
        
        current = SPs{i,j};
        for k=1:length(current)-1
            P(current(k),current(k+1)) = P(current(k),current(k+1))+1;
        end
        
    end
end

end