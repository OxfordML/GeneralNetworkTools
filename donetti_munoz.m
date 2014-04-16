function [Groups Qmonitor best_iteration best_group] = donetti_munoz(W,max_steps,plot_flag,group_closeness,M,distance_metric)
if ~exist('distance_metric','var')
    distance_metric = 'angular';
end

if ~exist('M','var')
    M = ceil(size(W,1)/4);
end

[Groups Qmonitor best_iteration best_group] = hierachical_clustering(W,max_steps,plot_flag,group_closeness,...
    'donetti_munoz',M,distance_metric);

end