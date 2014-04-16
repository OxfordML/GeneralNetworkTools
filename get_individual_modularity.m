function q= get_individual_modularity(elem,Groups,W,deltas)
group_number = max(size(Groups));

indices_by_groups = cat(2,Groups{:});
Wij = W(indices_by_groups,indices_by_groups);

S= get_strength(Wij);

Ti = repmat(S,1,N);
Tj = repmat(S',N,1);

DELTAS = zeros(N);

offset=0;
for i=1:group_number
    current_indices = offset+1:offset+1+(length(Groups{i})-1);
    DELTAS(current_indices,current_indices)=1;
    offset = offset+1+(length(Groups{i})-1);
   %DELTAS(Groups{i},Groups{i})=1; 
end

q = sum((Wij(elem,:) - (Ti(elem,:).*Tj(elem,:))/(2*m)).*DELTAS(elem,:))/(2*m);
%Q =sum(sum(     (Wij - (Ti.*Tj)/(2*m)).*DELTAS ))        /(2*m);

% N = size(W,1);
% m = sum(sum(W))/2;
% SumQ = 0;
% 
% if ~exist('deltas','var')
%     deltas = get_deltas(W,groups);
% end
% 
% for j=1:N
%     SumQ = SumQ + (W(i,j)-get_strength(W,i)*get_strength(W,j)/(2*m))*deltas(j,i);
% end
% 
% q = SumQ/(2*m);
end