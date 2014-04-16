function L = get_laplacian(W)
L = diag(sum(W));
W = -1*W;

L = L + W;
end