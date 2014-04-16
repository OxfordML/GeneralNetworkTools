function [z P Ki Kg Ksg] = get_network_cartography(W,groups)
%% INITIALIZATIONS
K = length(groups);
N = size(W,1);
Degrees = get_strength(W);

%% MEAN DEGREES
Ki = zeros(N,1);
for i=1:N
    current_group = get_individual_membership(i,groups);
    Ki(i) = sum(W(i,current_group));
end
%% z-SCORES
%get mean degrees and std for each group
Kg = zeros(K,1);
Ksg = zeros(K,1);
for k=1:K
  Kg(k) = mean(Ki(groups{k}));
  Ksg(k) = std(Ki(groups{k}));
end
Kg(Kg==0)=eps;
Ksg(Ksg==0)=eps;

%get z score
z=zeros(N,1);
for i=1:N
    [current_group group_index] = get_individual_membership(i,groups);
    z(i) = (Ki(i) - Kg(group_index))/Ksg(group_index);
end

%% Participation coefficient
P = zeros(N,1);
for i=1:N
   normalized_external_degrees = zeros(K,1);
   for k=1:K
       normalized_external_degrees(k) = sum(W(i,groups{k})) / Degrees(i);
   end
   
   P(i) = 1 - sum(normalized_external_degrees.^2);
end
end