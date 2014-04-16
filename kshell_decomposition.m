function SHELLS = kshell_decomposition(A,lambda)

if nargin<2
    lambda = 1;
end

k0 = sum(A);
km = k0;
m=0;

N = size(A,1);

pruned = false(1,N);

while sum(sum(A))~=0
    m = m + 1;
    
    shell_members = km<m;
    new_members = shell_members;
    while sum(new_members) ~=0
        A(shell_members,shell_members) = 0;
        km = sum(A);
        new_members = km<m;
        new_members(shell_members) = false;
        
        shell_members = or(shell_members,new_members);
    end
    
    shell_members(pruned) = false;
    
    pruned = or(pruned,shell_members);
    
    SHELLS{m} = shell_members;
end

for m=1:length(SHELLS)
    SHELLS{m} = find(SHELLS{m});
end

end