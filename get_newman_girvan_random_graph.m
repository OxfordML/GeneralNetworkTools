function [A, groups, pin, pout] = get_newman_girvan_random_graph(kin)
%% INITIALIZATION
C = 4;
N = 128;
group_size = N/C;%32

k=N/8;%16
kout = k-kin;

pin = kin/group_size;
pout = kout/(N-group_size);
pout_per_group = pout/(C-1);

%P = pin*eye(C);
% for i=1:C
%     d = pout/(C-1) * ones(C-1,1);
%     %d = gamrnd(d,1);
%     %d = pout * d./sum(d);
%     P(:,i) = vecInsert(pin,i,d);
% end

groups = cell(C,1);
index =1;
for i=1:C
   groups{i} = index:i*group_size;
   index = groups{i}(end)+1;
end

deltas = false(N);
for i=1:C
   deltas(groups{i},groups{i})=true; 
end

% A = rand(N);
% A(A(deltas)<=pin)=1;
% A(A(deltas)>pin)=1;
% 
% A(A(~deltas)<=pout_per_group)=1;
% A(A(~deltas)>pout_per_group)=1;

A = zeros(N);
for i=1:N-1
    for j=i+1:N
        dice = rand(1);
        if (deltas(i,j) && dice<=pin) || (~deltas(i,j) && dice<=pout_per_group)
            A(i,j)=1;
        end
    end
end
A = A+A';
end