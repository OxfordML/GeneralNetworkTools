function W = decompress_adjacency_matrix(W,symmetric_flag)

if issparse(W)
    W = full(W);
    %W(isnan(W))=0;
    
    if ~exist('symmetric_flag','var')
        symmetric_flag = true;
    end
    
    % rebuild low triangular part
    if symmetric_flag
        if ~is_symmetric(W)
            W = W + W';
        end
    end
end
end