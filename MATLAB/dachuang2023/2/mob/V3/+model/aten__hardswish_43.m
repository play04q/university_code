classdef aten__hardswish_43 < nnet.layer.Layer & nnet.layer.Formattable & ...
        nnet.layer.AutogeneratedFromPyTorch
    %aten__hardswish_43 Auto-generated custom layer
    % Auto-generated by MATLAB on 2024-03-29 21:50:34
    
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
        function obj = aten__hardswish_43(Name, Type, InputNames, OutputNames)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 1;
            obj.NumOutputs = 1;
            obj.InputNames = InputNames;
            obj.OutputNames = OutputNames;
        end
        
        function [hardswish_3] = predict(obj,hardswish_argument1_1)
            import model.ops.*;
            
            %Use the input format inferred by the importer to permute the input into reverse-PyTorch dimension order
            [hardswish_argument1_1, hardswish_argument1_1_format] = permuteToReversePyTorch(hardswish_argument1_1, 'BC', 2);
            [hardswish_argument1_1] = struct('value', hardswish_argument1_1, 'rank', int64(2));
            
            [hardswish_3] = pyHardSwish(hardswish_argument1_1);
            
            [hardswish_3] = labelWithPropagatedFormats(hardswish_3, "BC");
            hardswish_3 = hardswish_3.value ;
            
        end
        
        
        
        function [hardswish_3] = forward(obj,hardswish_argument1_1)
            import model.ops.*;
            
            %Use the input format inferred by the importer to permute the input into reverse-PyTorch dimension order
            [hardswish_argument1_1, hardswish_argument1_1_format] = permuteToReversePyTorch(hardswish_argument1_1, 'BC', 2);
            [hardswish_argument1_1] = struct('value', hardswish_argument1_1, 'rank', int64(2));
            
            [hardswish_3] = pyHardSwish(hardswish_argument1_1);
            
            [hardswish_3] = labelWithPropagatedFormats(hardswish_3, "BC");
            hardswish_3 = hardswish_3.value ;
            
        end
        
        
    end
end

