classdef aten__dropout_44 < nnet.layer.Layer & nnet.layer.Formattable
    %aten__dropout_44 Auto-generated custom layer
    % Auto-generated by MATLAB on 2024-02-25 23:48:23
    
    properties (Learnable)
        % Networks (type dlnetwork)
        
    end
    
    properties
        % Non-Trainable Parameters
        
        
        dropout_3
        
        
        dropout_4
        
        
    end
    
    properties (Learnable)
        % Trainable Parameters
        
    end
    
    methods
        function obj = aten__dropout_44(Name, Type, InputNames, OutputNames)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 2;
            obj.NumOutputs = 2;
            obj.InputNames = InputNames;
            obj.OutputNames = OutputNames;
        end
        
        function [dropout_input_1, dropout_input_1_rank] = predict(obj,dropout_argument1_1, dropout_argument1_1_rank)
            
            if ~contains(dims(dropout_argument1_1),'U')
                [dropout_argument1_1] = struct('value', dropout_argument1_1, 'rank', ndims(dropout_argument1_1));
            else
                [dropout_argument1_1] = struct('value', dropout_argument1_1, 'rank', int64(numel(dropout_argument1_1_rank)));
            end
            
            import model.ops.*;
            
            [dropout_3] = makeStructForConstant(single(obj.dropout_3), int64(0), "Typed");
            [dropout_4] = makeStructForConstant(int64(obj.dropout_4), int64(0), "Typed");
            [dropout_input_1] = pyDropout(dropout_argument1_1, dropout_3, false);
            [dropout_input_1_rank] = ones([1,dropout_input_1.rank]);
            dropout_input_1_rank = dlarray(dropout_input_1_rank,'UU');
            dropout_input_1 = dropout_input_1.value ;
            
        end
        
        
        
        function [dropout_input_1, dropout_input_1_rank] = forward(obj,dropout_argument1_1, dropout_argument1_1_rank)
            
            if ~contains(dims(dropout_argument1_1),'U')
                [dropout_argument1_1] = struct('value', dropout_argument1_1, 'rank', ndims(dropout_argument1_1));
            else
                [dropout_argument1_1] = struct('value', dropout_argument1_1, 'rank', int64(numel(dropout_argument1_1_rank)));
            end
            
            import model.ops.*;
            
            [dropout_3] = makeStructForConstant(single(obj.dropout_3), int64(0), "Typed");
            [dropout_4] = makeStructForConstant(int64(obj.dropout_4), int64(0), "Typed");
            [dropout_input_1] = pyDropout(dropout_argument1_1, dropout_3, true);
            [dropout_input_1_rank] = ones([1,dropout_input_1.rank]);
            dropout_input_1_rank = dlarray(dropout_input_1_rank,'UU');
            dropout_input_1 = dropout_input_1.value ;
            
        end
        
        
    end
end
