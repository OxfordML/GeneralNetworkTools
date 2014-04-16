function [A scripts] = analyse_scripts(target_directory,output_filename)


command = ['ls -LR ',target_directory,' | grep .m$'];
[r w] = unix(command);

scripts = strsplit(w,char(10));

total_scripts = length(scripts);

for i=1:total_scripts
    filename = strsplit(scripts{i},'.');
    scripts{i} = filename{1};
end

A = zeros(total_scripts);

%$ find / -name httpd.conf
% grep [string] file

for i=1:total_scripts
    100*i/total_scripts
    scripts{i}
    
    curr = scripts{i};
    
    if strfind(curr,'NMF_testspace')
        continue;
    end
    
    [r filepath] = unix(['find ',target_directory,' -name ',curr,'.m']);
    
    if r == 0
        for j=1:total_scripts
            if i~=j
                
                [r w] = unix(['grep ',scripts{j},'\( ',filepath]);
                
                if r==0
                    A(i,j) = ~isempty(w);
                    
                    if A(i,j)
                        scripts{j}
                        curr
                    end
                end
            end
        end
    end
    disp('----');
end


if exist('output_filename','var')
    export_GML(A,output_filename,scripts);
end

end