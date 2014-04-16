function r = get_assortativity_given_x(A,x)

%N = size(A,1);
k = sum(A)';

M = sum(k);

X = x*x';
K = k*k';

nominator = (A - (1/M) * K).*X;
denominator = (diag(k) - (1/M) * K).*X;

r = sum(sum(nominator)) / sum(sum(denominator));

end