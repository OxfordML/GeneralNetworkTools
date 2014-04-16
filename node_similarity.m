function S = node_similarity(W,similarity_measure,parameter1,parameter2)
A = 1*(W>0);
N = size(W,1);

if ~exist('similarity_measure','var')
    similarity_measure = 'donetti_munoz';
end

if strcmp(similarity_measure,'geodesic')
    %% similarity by geodesic distance
    S = get_node_distances(A);
    S = max(max(S)) - S;
elseif strcmp(similarity_measure,'degree')
    %% similarity by degree (crap)
    SPs = get_node_distances(A);
    S = zeros(N);
    for i=1:N
        for j=1:N
            if i~=j
                S(i,j) = degree(A,j)-degree(A,i) - SPs(i,j);
            end
        end
    end
elseif strcmp(similarity_measure,'co-occurence')
    %% similarity by co-occurences
    S = zeros(N,N);
    for i=1:N
        for j=1:N
            if i~=j
                S(i,j) =  W(i,j)/strength(W,j);
            end
        end
    end
elseif strcmp(similarity_measure,'donetti_munoz')
    %% Donetti Munoz method
    L = get_laplacian(W);
    [V D] = eig(L);
    
    if ~exist('parameter1','var') || (exist('parameter1','var') && parameter1>N) || parameter1==-1
        parameter1 = ceil(N/4);
    end
    
    M=parameter1;
    %find projection space
    PS = V(:,N-M+1:N);
    
    if ~exist('parameter2','var')
        parameter2='angular';
    end
    
    if strcmp(parameter2,'angular')
        %angular distsance
        S = PS*PS'./(repmat(sqrt(sum(PS.^2,2)),1,N).*repmat(sqrt(sum(PS.^2,2))',N,1));
        S = abs(S);
    else
        S = zeros(N);
        %eucledian distance
        for i=1:N
            for j=1:N
                S(i,j) = norm(PS(i,:)-PS(j,:),2);
            end
        end
    end
    
    S(~A)=-inf;
elseif strcmp(similarity_measure,'capocci')
    %% Capocci method
    % get normal matrix
    Normal = W./sum(sum(W));
    
    [V D] = eig(Normal);
    
    S = get_pearson_matrix(V);
    S(~A)=-inf;
elseif strcmp(similarity_measure,'pearson')
    %% Pearson
    S = get_pearson_matrix(W);
    S(~A)=-inf;
end
end