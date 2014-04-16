function [U] = commdetU (x, c)

c = c - diag(diag(c)); % just in case diagonal has 1's
N = size(c,1);
k = sum(c);
m = sum(k)/2;
U = 0;
for i=1:N,
    for j=1:N,
        if x(i) == x(j),
            U = U + c(i,j) - k(i)*k(j)/(2*m);
            %disp([i j c(i,j) k(i) k(j) U])
        end
    end
end
U = U / (2*m);
