classdef aten__mul16 < nnet.layer.Layer & nnet.layer.Formattable
    %aten__mul16 Auto-generated custom layer
    % Auto-generated by MATLAB on 2024-02-25 23:48:21
    
    properties (Learnable)
        % Networks (type dlnetwork)
        
    end
    
    properties
        % Non-Trainable Parameters
        
    end
    
    properties (Learnable)
        % Trainable Parameters
        
    end
    
    methods
        function obj = aten__mul16(Name, Type, InputNames, OutputNames)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 3;
            obj.NumOutputs = 1;
            obj.InputNames = InputNames;
            obj.OutputNames = OutputNames;
        end
        
        function [mul_input_1] = predict(obj,mul_24, mul_argument1_1, mul_24_rank)
            
            if ~contains(dims(mul_24),'U')
                [mul_24] = struct('value', mul_24, 'rank', ndims(mul_24));
            else
                [mul_24] = struct('value', mul_24, 'rank', int64(numel(mul_24_rank)));
            end
            
            if ~contains(dims(mul_argument1_1),'U')
                [mul_argument1_1] = struct('value', mul_argument1_1, 'rank', ndims(mul_argument1_1));
            else
                [mul_argument1_1] = struct('value', mul_argument1_1, 'rank', int64(ndims(mul_argument1_1)));
                warning(message('nnet_cnn_pytorchconverter:pytorchconverter:PossibleLossOfRank', 'mul_argument1_1', 'aten__mul16'));
            end
            
            import model.ops.*;
            
            [mul_input_1] = pyElementwiseBinary(mul_24, mul_argument1_1, 'times');
            
            [mul_input_1] = labelWithPropagatedFormats(mul_input_1, "*CSS");
            mul_input_1 = mul_input_1.value ;
            
        end
        
        
        
        function [mul_input_1] = forward(obj,mul_24, mul_argument1_1, mul_24_rank)
            
            if ~contains(dims(mul_24),'U')
                [mul_24] = struct('value', mul_24, 'rank', ndims(mul_24));
            else
                [mul_24] = struct('value', mul_24, 'rank', int64(numel(mul_24_rank)));
            end
            
            if ~contains(dims(mul_argument1_1),'U')
                [mul_argument1_1] = struct('value', mul_argument1_1, 'rank', ndims(mul_argument1_1));
            else
                [mul_argument1_1] = struct('value', mul_argument1_1, 'rank', int64(ndims(mul_argument1_1)));
                warning(message('nnet_cnn_pytorchconverter:pytorchconverter:PossibleLossOfRank', 'mul_argument1_1', 'aten__mul16'));
            end
            
            import model.ops.*;
            
            [mul_input_1] = pyElementwiseBinary(mul_24, mul_argument1_1, 'times');
            
            [mul_input_1] = labelWithPropagatedFormats(mul_input_1, "*CSS");
            mul_input_1 = mul_input_1.value ;
            
        end
        
        
    end
end

