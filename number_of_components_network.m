function [C eigenvalues] = number_of_components_network(A)

L = get_laplacian(A);
[V,D] = eig(L);

eigenvalues = diag(D);

C = sum(1*(eigenvalues<eps));
end