function A = get_ER_graph_Np(N,p)

A = binornd(1,p,N,N);
% is_connected = false;
% while ~is_connected
% A = zeros(N);
% for i=1:N-1
%     for j=i+1:N
%         coin = rand(1);
%         if coin<p
%             A(i,j) = 1;
%             A(j,i) = 1;
%         end
%     end
% end
% 
% L = get_laplacian(A);
% [V,D] = eig(L);
% 
% is_connected = sum(1*(diag(D)<eps))==1;
% end
end