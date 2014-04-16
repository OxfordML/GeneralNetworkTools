function A = build_distributed_adjacency_matrix(N,DATA,weight_construction_function)
matlabpool('size')
%% initial
A = zeros(N);

if ~exist('w','var')
    w = max(factor(N)); % width of partition
end
p = N/w; % N / w  number of partitions across one dimension

d = zeros((p^2 - p)/2 + p,2); %number_of_partitions X 2, d(iterator,:) = partition coordinates

%V = B'*B;

iterator = 0;
for i=1:p
    for j=i:p
        iterator = iterator + 1;
        d(iterator,1) = i;
        d(iterator,2) = j;
    end
end

A_CONTAINER = cell(size(d,1),1);

%% get partition ranges
%tic
%K = 0;

d1 = d(:,1);
d2 = d(:,2);
%K = 0;
%pmm = ParforProgMon('Partitioning...',size(d,1));
%K = 0;
disp('partitioning...')
for k=1:size(d,1)
    
    %DATA_LOCAL = DATA;
    
    p1 = d1(k);
    p2 = d2(k);
    
    row_index_range = (p1-1)*w+1:p1*w;
    col_index_range = (p2-1)*w+1:p2*w;
    
    
    %
    %tic
    effective_indices = sparse(or((and(DATA(:,1) >= row_index_range(1),DATA(:,1) <= row_index_range(end))),...
        (and(DATA(:,1) >= col_index_range(1),DATA(:,1) <= col_index_range(end)))));
    %toc
    
    %tic
    DATA_SHRINKED = DATA(effective_indices,:);
    %toc
    
    %tic
    A_partition = adjacency_partition(DATA_SHRINKED,row_index_range,col_index_range,p1==p2);
    %toc
    
    A_CONTAINER{k} = A_partition;
    
    %    pmm.increment();
    %progressbar(k/size(d,1));
    %K = K + 1
end
%save('A_PARTITIONS.mat')
%toc
%% calculate distances
%pmm = ParforProgMon('Partitioning...',size(d,1));
% K = 0;
disp('building local matrices...')
tic
K=0;
parfor k=1:size(d,1)
    A_partition = A_CONTAINER{k};
    
    % SNP similarity calculation here:
    A_partition.A = weight_construction_function(A_partition);
    
    A_CONTAINER{k} = A_partition;
    
    %K = K + 1
end
toc

%% reconstruct
disp('reconstructing...')
%K=0;
tic
for k=1:size(d,1)
    A_partition = A_CONTAINER{k};
    
    A(A_partition.row_index_range,A_partition.col_index_range) = A_partition.A;
    
    %K = K + 1;
end
toc

A = compress_adjacency_matrix(A);
end