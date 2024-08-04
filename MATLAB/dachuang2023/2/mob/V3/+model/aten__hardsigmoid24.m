classdef aten__hardsigmoid24 < nnet.layer.Layer & nnet.layer.Formattable & ...
        nnet.layer.AutogeneratedFromPyTorch
    %aten__hardsigmoid24 Auto-generated custom layer
    % Auto-generated by MATLAB on 2024-03-29 21:50:33
    
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
        function obj = aten__hardsigmoid24(Name, Type, InputNames, OutputNames)
            obj.Name = Name;
            obj.Type = Type;
            obj.NumInputs = 1;
            obj.NumOutputs = 1;
            obj.InputNames = InputNames;
            obj.OutputNames = OutputNames;
        end
        
        function [hardsigmoid_3] = predict(obj,hardsigmoid_argument1_1)
            import model.ops.*;
            
            %Use the input format inferred by the importer to permute the input into reverse-PyTorch dimension order
            [hardsigmoid_argument1_1, hardsigmoid_argument1_1_format] = permuteToReversePyTorch(hardsigmoid_argument1_1, 'BCSS', 4);
            [hardsigmoid_argument1_1] = struct('value', hardsigmoid_argument1_1, 'rank', int64(4));
            
            [hardsigmoid_3] = pyHardSigmoid(hardsigmoid_argument1_1);
            
            [hardsigmoid_3] = labelWithPropagatedFormats(hardsigmoid_3, "BCSS");
            hardsigmoid_3 = hardsigmoid_3.value ;
            
        end
        
        
        
        function [hardsigmoid_3] = forward(obj,hardsigmoid_argument1_1)
            import model.ops.*;
            
            %Use the input format inferred by the importer to permute the input into reverse-PyTorch dimension order
            [hardsigmoid_argument1_1, hardsigmoid_argument1_1_format] = permuteToReversePyTorch(hardsigmoid_argument1_1, 'BCSS', 4);
            [hardsigmoid_argument1_1] = struct('value', hardsigmoid_argument1_1, 'rank', int64(4));
            
            [hardsigmoid_3] = pyHardSigmoid(hardsigmoid_argument1_1);
            
            [hardsigmoid_3] = labelWithPropagatedFormats(hardsigmoid_3, "BCSS");
            hardsigmoid_3 = hardsigmoid_3.value ;
            
        end
        
        
    end
end
