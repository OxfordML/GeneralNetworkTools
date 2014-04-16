function Q = get_weighted_modularity(Groups_initial,W,current_step)

if ~exist('current_step','var')
    current_step=1;
end

max_partitions = max(size(Groups_initial));
partitions = 0;
for row_index = 1:max_partitions
    if ~isempty(Groups_initial{current_step,row_index})
        partitions = partitions+1;
    end
end

Groups_q = cell(partitions,1);
aux_it=1;
for row_index=1:max_partitions
    if ~isempty(Groups_initial{current_step,row_index})
        Groups_q{aux_it} = Groups_initial{current_step,row_index};
        aux_it=aux_it+1;
    end
end

e = zeros(partitions);
total_weight = sum(sum(triu(W)));

for row_index=1:partitions
    for col_index=1:partitions
        if row_index == col_index
            e(row_index,col_index) = sum(sum(triu(W(Groups_q{row_index},Groups_q{col_index}))))/total_weight;
        else
            e(row_index,col_index) = sum(sum((W(Groups_q{row_index},Groups_q{col_index}))))/total_weight;
        end
    end
end

a = sum(e,2);

Q = sum(diag(e)-a.^2);
end