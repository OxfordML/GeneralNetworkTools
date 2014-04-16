function export_matrix_to_LaTeX(A,tablename,filename,integer_flag)

if ~exist('integer_flag','var')
    integer_flag = false;
end

[rows cols] = size(A);

fid = fopen(filename,'w');

fprintf(fid,strcat('\mathbf{',tablename,'} = '));

fprintf(fid,'\\left[\\begin{array}{');

for j=1:cols
    fprintf(fid,'c');
end

fprintf(fid,'}\n');

if integer_flag
    for i=1:rows
        for j=1:cols
            fprintf(fid,'%d ',A(i,j));
            
            if j<cols
                fprintf(fid,'& ');
            else
                if i<rows
                    fprintf(fid,'\\\\\n');
                else
                    fprintf(fid,'\\end{array} \\right]');
                end
            end
        end
    end
else
    for i=1:rows
        for j=1:cols
            if A(i,j)~=0
                fprintf(fid,'%.2f ',A(i,j));
            else
                fprintf(fid,'0');
            end
            
            if j<cols
                fprintf(fid,'& ');
            else
                if i<rows
                    fprintf(fid,'\\\\\n');
                else
                    fprintf(fid,'\\end{array} \\right]');
                end
            end
        end
    end
end



end