function B = get_modularity_matrix(W)
N = size(W,1);
S= get_strength(W);
m = sum(sum(W))/2;

Ti = repmat(S,1,N);
Tj = repmat(S',N,1);

B = W - (Ti.*Tj)/(2*m);
end