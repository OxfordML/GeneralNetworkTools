function is = is_partition_complete(groups,A)
N = size(A,1);
r = 1:N;
n = sort(cat(2,groups{:}));

is = prod(1*(r==n));
end