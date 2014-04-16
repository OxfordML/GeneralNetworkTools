function S = get_network_square_error_distance(A,B)
N = size(A,1);

n = get_number_of_triu_elements_matrix(N);

S = 0;
for i=1:N-1
    for j=i+1:N
        S = S + (A(i,j) - B(i,j))^2;
    end
end

S = S / n;

end