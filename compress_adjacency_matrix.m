function W = compress_adjacency_matrix(W,symmetric_flag)

if nargin<2
    symmetric_flag = 1;
end

if symmetric_flag
    W = triu(W,1);
end

W = sparse(W);

end