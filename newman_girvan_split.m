function [group1 group2 modularity] = newman_girvan_split(W,aux_indices)
%% INITIALIZE
A = W>0;
N = size(A,1);

if ~exist('aux_indices','var')
    aux_indices = 1:N;
end

PopularEdges = zeros(N,N,N);

%Aoriginal = A;
Woriginal = W;
%iteration=1;

%separation_flag=false;

%% STEPS
while true;
    %% (RE)CALCULATE POPULARITIES GIVEN STEP
    for startnode=1:N
        [distances weights] = weighted_shortest_paths(W,startnode);
        
        if isinf(sum(distances))
            %separation_flag=true;
            group1 = find(~isinf(distances));
            group2 = find(isinf(distances));
            
            modularity = get_modularity({group1;group2},W)
            
            group1 = aux_indices(find(~isinf(distances)));
            group2 = aux_indices(find(isinf(distances)));
            return;
        else
            SP = weighted_SP_tree(W,distances,weights,startnode);
            PopularEdges(:,:,startnode) = edge_popularity_given_startnode(W,startnode,distances,weights,SP);
        end
    end
    %% REMOVE MOST POPULAR EDGE
    %if ~separation_flag
    %end
    P=sum(PopularEdges(:,:,:),3)./W;
    %iteration = iteration+1;
    [x y] = find_matrix_max(P);
    A(x,y)=0;
    A(y,x)=0;
    W(x,y)=0;
    W(y,x)=0;
    
    %         x
    %         y
    %         disp('-----------')
end
end

%% GET MODULARITY FOR GIVEN SPLIT
%     function m = get_mod(group1,group2,W)
%         %A = W>0;
%         total_edges = sum(sum(triu(W)));
%         e = zeros(2);
%         
%         e(1,1) = sum(sum(triu(W(group1,group1))));
%         e(2,2) = sum(sum(triu(W(group2,group2))));
%         e(2,1) = sum(sum(W(group2,group1)));
%         e(1,2) = e(2,1);
%         
%         e = e./total_edges;
%         a = sum(e,2);
%         
%         m = trace(e) - sum(a.^2);
%     end