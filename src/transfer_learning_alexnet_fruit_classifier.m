% LOAD DATA
% first download FruitsData.zip here: https://drive.google.com/file/d/1O2ID_qzmz_T_Uimo4cRqUoGWm9w6m_qB/view?usp=sharing 
% then unzip it inside src folder
imds = imageDatastore('FruitsData', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% SPLIT TRAIN AND TEST DATA
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.7,'randomized');

% LOAD PRETRAINED NETWORK
net = alexnet;      % we will use pretrained AlexNet

% REPLACE FINAL LAYERS
% Extract all layers, except the last three, from the pretrained network.
layersTransfer = net.Layers(1:end-3);

% get number of labels from train data
numClasses = numel(categories(imdsTrain.Labels));

% create 3 new layers to be appended to layersTransfer
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];

% DATA AUGMENTATION
% reflection and translation: prevents the network from overfitting
pixelRange = [-30 30];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange);

% resize training data so that it can be feed into the model 
inputSize = net.Layers(1).InputSize;
augimdsTrain = augmentedImageDatastore([227 227],imdsTrain, ...
    'ColorPreprocessing', 'gray2rgb', ...
    'DataAugmentation',imageAugmenter);

% resize the validation data automatically
augimdsValidation = augmentedImageDatastore([227 227],imdsValidation, 'ColorPreprocessing', 'gray2rgb');

% SPECIFY THE TRAINING OPTIONS
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',10, ...
    'InitialLearnRate',1e-4, ...     % set the initial learning rate to a small value to slow down learning in the transferred layers       
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');

% TRAIN THE NETWORK
netTransfer = trainNetwork(augimdsTrain,layers,options);

% CLASSIFY VALIDATION IMAGES
[YPred,scores] = classify(netTransfer,augimdsValidation);

% CALCULATE CLASSIFICATION ACCURACY ON VALIDATION SET
YValidation = imdsValidation.Labels;
accuracy = mean(YPred == YValidation)

% SAVE TRAINED MODEL
save ('trained_fruit_classifier_034_042.mat', 'netTransfer')