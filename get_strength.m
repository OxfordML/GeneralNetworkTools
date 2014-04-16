function s = get_strength(W,i)
if ~exist('i','var')
    i=1:size(W,1);
end

s = sum(W(i,:),2);
end