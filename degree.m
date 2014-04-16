function k = degree(A,nodes)
A(A~=0)=1;

if ~exist('nodes','var')
    nodes = 1:1:size(A,1);
end

k=sum(A(nodes,:),2);
end