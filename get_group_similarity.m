function Sg = get(groups,S,group_closeness,W)
if ~exist('group_closeness','var')
    group_closeness = 'complete-linkage';
end

Ng = length(groups);
Sg = -inf*ones(Ng);
if strcmp(group_closeness,'complete-linkage')
    for i=1:Ng
        for j=1:Ng
            if i~=j && sum(sum(W(groups{i},groups{j})))~=0
                Sg(i,j) = max(max(S(groups{i},groups{j})));
            end
        end
    end
elseif strcmp(group_closeness,'single-linkage')
    for i=1:Ng
        for j=1:Ng
            if i~=j && sum(sum(W(groups{i},groups{j})))~=0
                Sg(i,j) = min(min(S(groups{i},groups{j})));
            end
        end
    end
elseif strcmp(group_closeness,'group-average')
    for i=1:Ng
        for j=1:Ng
            if i~=j && sum(sum(W(groups{i},groups{j})))~=0
                Sg(i,j) = mean(mean(S(groups{i},groups{j})));
            end
        end
    end
end

end