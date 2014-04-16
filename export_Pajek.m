function export_Pajek(W,filename)
%% initialise
N = size(W,1);
M = sum(sum(1*(W>0)))/2;

fid = fopen(filename,'w');

%% vertices
fprintf(fid,'*Vertices %d\n',N);

for i=1:N
   fprintf(fid,' %d \"%d\"\n',i,i);
end

%% edges
fprintf(fid,'*Edges %d\n',M);

for i=1:N-1
    for j=i+1:N
        if W(i,j)~=0
            fprintf(fid,' %d %d %.2f\n',i,j,W(i,j));            
        end
    end
end

%% close
fclose(fid);
end