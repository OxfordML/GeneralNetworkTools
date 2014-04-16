N = max(max(DATA));
A = zeros(N);

n = size(DATA,1);

for i=1:n
    A(DATA(i,1),DATA(i,2))=1;
end

clear n;
clear i;