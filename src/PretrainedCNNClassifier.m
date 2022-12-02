classdef PretrainedCNNClassifier
    methods (Static)
        function [YPred, score] = predict(image)
            % load fine-tuned model
            file = load("trained_fruit_classifier_034_042.mat");
            newnet = file.netTransfer;

            % resize image
            im = imresize(image, [227 227]);
            
            % classify image
            [YPred,scores] = classify(newnet, im);

            % get highest score
            score = int8(max(scores))*100;
            score = int2str(score);
        end
    end
end