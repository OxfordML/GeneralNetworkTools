function ps = get_degree_distribution(W,plot_out)
% if ~exist('X','var')
%     X = ones(size(W,1),1);
% end
%% remove inactive
active_nodes = sum(W)~=0;
W = W(active_nodes,active_nodes);

%%
W = 1*logical(W);

degrees = sum(W);
degree_range = 1:max(degrees);

%% get distribution
ps = histc(degrees,degree_range);

%% plot
if exist('plot_out','var') && plot_out
   bar(degree_range,ps)
end
end