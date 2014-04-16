function p = get_weight_betweeness_coefficient(B,W)

%% remove diagonal elements
% W
W1 = triu(W);
W2 = tril(W);

W1(end,:)=[];
W2(1,:)=[];

W = W1+W2;

% B
B1 = triu(B);
B2 = tril(B);

B1(end,:)=[];
B2(1,:)=[];

B = B1+B2;

p = get_pearson_coefficient(B(:),W(:));

end