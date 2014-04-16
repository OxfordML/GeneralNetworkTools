function [c, C] = get_clustering_coefficient(A)

k = sum(A)';
c = diag(A*A*A) ./ (k.^2 - k);
c(isnan(c)) = 0;
C = mean(c);
end