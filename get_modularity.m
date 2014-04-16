function Q = get_modularity(partition,W,directed_flag)

if nargin<3
    directed_flag=false;
end

if iscell(partition)
    B = group_to_incidence_matrix(partition);
else
    B = partition;
end

K = size(B,2);


if ~directed_flag
    if K == 1
        Q = 0;
    else
        e = (1/sum(sum(W)))* B' * W * B;
        
        Q = trace(e) - sum(sum(e^2));
    end
else
    M = sum(sum(W));
    N = size(W,1);
    Q = 0;
    B = B';
    
    k_in = sum(W);
    k_out = sum(W,2);
    for i=1:N
       for j=1:N
          if i~=j
              k_i_in = k_in(i);
              k_j_out = k_out(j);
              
              delta_ij = logical(B(:,i)'*B(:,j));
              
              if delta_ij
                 Q = Q + (W(i,j) - (k_i_in*k_j_out/M)); 
              end
          end
       end
    end
    Q = Q / M;
    
end
end

function B = group_to_incidence_matrix(groups)
K = length(groups);
N = length(cat(2,groups{:}));

B = zeros(N,K);

for i=1:K
    B(groups{i},i) = 1;
end
end