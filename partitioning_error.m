function [C mean_similarity similarities] = partitioning_error(g,gs)

C = zeros(max(size(g)),max(size(gs)));


for i=1:size(C,1)
    for j=1:1:size(C,2)
        % identify jaccard similarity
        C(i,j)=length(intersect(g{i},gs{j}))/length(union(g{i},gs{j}));
        
        % just measure common elements
        %C(i,j)=length(intersect(g{i},gs{j}))/length(g{i});
    end
end

maxes = zeros(length(g));
for i=1:length(g)
   maxes(i)=find(C(i,:)==max(C(i,:)),1);
end

deltas = zeros(length(g),length(gs));
for i=1:length(g)
   deltas(i,maxes(i))=1;
end

% C(C==0)=eps;
% deltas(deltas==0)=eps;
% 
% KL = zeros(length(g),1);
% for i=1:length(g)
%     KL(i) = sum(   C(i,:) .* log( C(i,:)./deltas(i,:) )          );
% end
% 
% d=mean(KL);

similarities = zeros(length(g),1);
for i=1:length(similarities)
    %dot prod
    %similarities(i) = ( C(i,:)*deltas(i,:)' ) / ( norm(C(i,:)) * norm(deltas(i,:)) );
    
    %variation distance
    similarities(i) = sum(abs(deltas(i,:) - C(i,:)));
end

mean_similarity = mean(similarities);

end