function B = get_greedy_allocation_matrix(W)

N = size(W,1);
K = size(W,2);
B = zeros(N,K);

for i=1:N
   [m m_i] = max(W(i,:));
   B(i,m_i) = 1;   
end

end