function [group_index isunique] = find_group_membership(groups,elem)
Ng = length(groups);
for i=1:Ng
   if  prod(1*(ismember(elem,groups{i})))==1
       group_index = i;
       isunique=length(groups{i})==1;
       return;
   end
end

group_index=0;
end