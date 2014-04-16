function A = build_network_manually(N,is_directed)
if nargin<2
    is_directed = false;
end


A = zeros(N);

if ~is_directed
    
    i = 1;
    while i<=N
        fprintf('Enter a neighbour for node %d or next',i);
        answer = input('>','s');
        j = str2double(answer);
        
        if strcmp('answer','quit')
            A = nan;
            return;
        elseif isnan(j)
            i = i + 1;
            continue;
        else
            A(i,j) = 1;
        end
    end
    
    A = 1*logical(A + A');
    
else
    i = 1;
    while i<=N
        fprintf('Enter target for node %d or next',i);
        answer = input('>','s');
        j = str2double(answer);
        
        if strcmp('answer','quit')
            A = nan;
            return;
        elseif isnan(j)
            i = i + 1;
            continue;
        else
            A(i,j) = 1;
        end
    end
    
end

end