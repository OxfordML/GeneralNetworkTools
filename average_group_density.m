function D = average_group_density(group,W)
% N=size(W,1);
groups = max(size(group));

D=0;

for i=1:groups
    
    Wc = W(group{i},group{i});
    
    if sum(size(Wc))~=2
        
        Wup = triu(Wc,1);
        Wup=Wup(:);
        Wup(Wup==0)=[];
        
        Wlo = tril(Wc,-1);
        Wlo=Wlo(:);
        Wlo(Wlo==0)=[];
        
        D = D + mean([Wup;Wlo]);
    end
end

D = D/groups;
end