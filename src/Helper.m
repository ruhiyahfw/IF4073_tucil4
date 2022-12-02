classdef Helper
    methods (Static)
        function res = isGrayscale(image)
            res = size(image,3) == 1;
        end
    end
end
         