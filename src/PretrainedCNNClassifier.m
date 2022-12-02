classdef PretrainedCNNClassifier
    methods (Static)
        function YPred = predict(image)
            % load fine-tuned model
            file = load("trained_fruit_classifier_034_042.mat");
            newnet = file.netTransfer;

            % resize image
            im = imresize(image, [227 227]);
            
            % classify image
            [YPred,scores] = classify(newnet, im);
        end
    end
end