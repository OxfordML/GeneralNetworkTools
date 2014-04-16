classdef adjacency_partition < handle
    
    properties
        A;
        row_index_manager;
        col_index_manager;
        is_diagonal;
        DATA;
        
        row_index_range;
        col_index_range;
    end
    
    properties(Constant,Hidden)
        
    end
    
    methods
        function obj = adjacency_partition(DATA_SHRINKED,row_index_range,col_index_range,is_diagonal)
            obj.A = zeros(length(row_index_range),length(col_index_range));
            obj.DATA = DATA_SHRINKED;            
            
            obj.row_index_range = row_index_range;
            obj.col_index_range = col_index_range;
            
            obj.row_index_manager = index_manager(row_index_range);
            obj.col_index_manager = index_manager(col_index_range);
            
            obj.is_diagonal = is_diagonal;
        end
    end
end