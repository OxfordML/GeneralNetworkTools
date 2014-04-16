function [Win Wout Wavg] = get_average_weight(Groups,W)

N = size(W,1);

% W = W ./ repmat(diag(W),1,N);
% W(W==diag(diag(W)))=0;

Wavg = mean(mean(W));

group_number = size(Groups,1);

Win = zeros(group_number,1);
Wout = zeros(group_number,1);

for i=1:group_number
   group_indices = Groups{i};
   other_indices = setxor(1:N,group_indices);
   
   %W GROUP
   Wgroup = W(group_indices,group_indices);
   for j=1:length(group_indices)
       for k=1:length(group_indices)
           if j~=k
               Win(i) = Win(i) + Wgroup(j,k);
           end
       end
   end
   Win(i) = Win(i)/(length(group_indices)^2 - length(group_indices));
       
   %W NON GROUP
   Wout(i) = mean(mean(W(group_indices,other_indices)));
   
end
end