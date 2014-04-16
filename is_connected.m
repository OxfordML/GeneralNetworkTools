function [is_connected num_components] = is_connected(A)
L = get_laplacian(A);
[V,D] = eig(L);

num_components = sum( 1*(diag(D) < eps) );

is_connected = num_components == 1;
end