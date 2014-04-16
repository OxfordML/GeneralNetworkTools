function [group group_index ingroup_index] = get_individual_membership(element,groups)
group_number=max(size(groups));

for i=1:group_number
   membership = element==groups{i};
   if sum(membership)==1
       group_index=i;
       group = groups{i};
       ingroup_index = find(membership);
       return;
   end
end

group=0;
ingroup_index=0;
end