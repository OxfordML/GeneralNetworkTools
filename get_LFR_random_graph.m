function [A groups B N] = get_LFR_random_graph(N,kavg,kmax,gamma,beta,mu,minc,maxc)

build_parameter_file(N,kavg,kmax,gamma,beta,mu,minc,maxc);

unix('generate_nonoverlap/./benchmark')
[A B groups] = read_Lancichinetti_nonoverlap('network.dat','community.dat');

end
% rand('seed',now);
% % generate degree distribution
% k = kmin:kmax;
% pk = k.^(-gamma) ./ sum(k.^(-gamma));
% kavg = sum(k.*pk);
%
% % generate community size distribution
% s = smin:smax;
% ps = s.^(-beta) ./ sum(s.^(-beta));
% savg = sum(s.*ps);
%
% configuration_succeeded = false;
% while ~configuration_succeeded
%     %% assign each node a degree / generate the degree sequence
%     degrees = zeros(N,1);
%     for i=1:N
%         % sample pk
%         u = rand(1) * max(pk);
%         target_p = abs(pk-u);
%         index = find(target_p==min(target_p),1);
%
%         degrees(i) = k(index);
%     end
%
%     % sum of degrees must be even to represent connected pairs
%     if mod(sum(degrees),2)==1
%         node1 = 1+floor(rand(1)*N);
%         while degrees(node1)==1
%             node1 = 1+floor(rand(1)*N);
%         end
%         degrees(node1) = degrees(node1) - 1 ;
%     end
%
%     %% configuration model for node wiring using Havel-Hakimi model
%     % sort degrees in descending order
%     degrees = sort(degrees,1,'descend');
%     % free slots for each node
%     stubs = degrees;
%
%     A = zeros(N);
%     index = 0;
%     while index<N
%         index = index+1;
%
%         d = stubs(index);
%         if d==0
%             continue
%         elseif index+d>N
%             break;
%         end
%
%         A(index,index+1:index+d)=1;
%
%         stubs(index) = 0;
%
%         stubs(index+1:index+d) = stubs(index+1:index+d) - 1;
%     end
%     A = A + A';
%     %% Check conditions that the generated network is valid
%     % find Laplacian
%     L = get_laplacian(A);
%     [V,D] = eig(L);
%
%     if sum(stubs)==0 && sum(diag(D)<eps*10)==1
%         configuration_succeeded = true;
%     end
% end
% %node1 = 1+floor(rand(1)*N);
% % while sum(stubs)~=0
% %     %choose 1st node
% %     while stubs(node1)==0
% %         non_full_stubs = stubs~=0;
% %         u = 1+floor(rand(1)*sum(non_full_stubs));
% %         node1 = find(non_full_stubs,u);
% %         node1 = node1(end);
% %     end
% %
% %     try
% %         % find non-full nodes
% %         non_full_stubs = stubs~=0;
% %         % deselect connected
% %         non_full_stubs = (A(:,node1)==0).*non_full_stubs;
% %         % deselect node1
% %         non_full_stubs(node1)=0;
% %
% %         %choose 2nd node
% %
% %         u = 1+floor(rand(1)*sum(non_full_stubs));
% %         node2 = find(non_full_stubs,u);
% %
% %         if isempty(node2)
% %             continue;
% %         end
% %
% %         node2 = node2(end);
% %     catch ME
% %         ME.stack;
% %     end
% %
% %     if A(node1,node2)==0
% %         % connect the two nodes
% %         A(node1,node2) = 1;
% %         A(node2,node1) = 1;
% %         stubs(node1) = stubs(node1) - 1;
% %         stubs(node2) = stubs(node2) - 1;
% %     end
% %
% %     node1 = node2;
% % end
% %% generate communities
% groups = cell(0);
% total_sizes = 0;
% community_sizes = [];
% K = 0;
% convergence_countdown = 0;
% while total_sizes~=N
%     include_community = false;
%
%     % sample ps
%     u = rand(1) * max(pk);
%     target_p = abs(ps-u);
%     index = find(target_p==min(target_p),1);
%
%     if total_sizes+s(index)<=N
%         include_community = true;
%         convergence_countdown = 0;
%     else
%         convergence_countdown = convergence_countdown + 1;
%     end
%
%     if include_community
%         K=K+1;
%         community_sizes(K) = s(index);
%         total_sizes = total_sizes + s(index);
%     elseif convergence_countdown > 100
%         K = K+1;
%         community_sizes(K) = N-total_sizes;
%     end
% end
% % build participation matrix
% B = false(zeros(N,K));
% % build community loads
% community_loads = zeros(size(community_sizes));
% %% assign nodes to communities
% assigned = zeros(N,1);
%
% % degree-based allocation
% %iterator = 0;
% while prod(assigned)==0
%     % select a random unassigned node
%     no_unassigned = sum(assigned==0);
%     node_index = 1+floor(rand(1)*no_unassigned);
%     node = find(assigned == 0,node_index);
%     node = node(end);
%
%     % find non-full communities
%     non_full_communities = community_loads < community_sizes;
%     no_non_full_communities = sum(non_full_communities);
%     % select a random non-full community
%     comm_index = 1+floor(rand(1)*no_non_full_communities);
%     comm = find(community_loads < community_sizes,comm_index);
%     comm = comm(end);
%
%     % node insertion
%     if degrees(node)*(1-mu)<community_sizes(comm)
%         B(node,comm) = 1;
%         assigned(node) = 1;
%     end
%
%     %iterator = iterator+1;
% end
%
% % membership shift
% for i=1:N
%     current_comm = (B(i,:));
%
%     e = zeros(K,1);
%     for k=1:K
%         e(k) = sum(A(i,(B(:,k))))/N;
%     end
%
%     max_comm = find(e == max(e),1);
%
%     if sum(B(:,current_comm))~=2
%        B(i,current_comm) = 0;
%        B(i,max_comm) = 1;
%     end
% end
%
% % re-wirings to sustain 1-mu
% for i=1:N
%    kin_curr = sum(A(B(:,B(i,:)),i));
%    kin_req = sum(A(:,i))*(1-mu);
%
%    if kin_curr < kin_req
%        no_links_to_switch = floor(kin_req - kin_curr);
%        for j=1:no_links_to_switch
%            % neighbours
%            neighbours = find(A(:,i));
%            % select a random node inside the comm
%            candidate_node = neughbours(1+floor(rand*length(neighbours)));
%        end
%    end
% end
% %% produce observed groups
% groups = cell(K,1);
% for k=1:K
%     groups{k} = find(B(:,k));
% end
% end