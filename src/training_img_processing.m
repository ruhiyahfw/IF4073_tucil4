%Training
cd('FruitsData');
fruitdata = {'apple';'banana';'orange';'melon';'pear'};
countfruit = length(fruitdata);
for i = 1:countfruit
    cd(char(fruitdata(i)));
    citradata = dir('*jpg');
    countdata = length(citradata);
    for j=1:countdata
        filename = citradata(j).name;
        if size(imread(filename),3) == 1
            xcitra = imread(filename);
        else
            xcitra = rgb2gray(imread(filename));
        end
        features = graycoprops(graycomatrix(xcitra));
        featuresmat(j+countdata*(i-1),1) = features.Contrast;
        featuresmat(j+countdata*(i-1),2) = features.Correlation;
        featuresmat(j+countdata*(i-1),3) = features.Energy;
        featuresmat(j+countdata*(i-1),4) = features.Homogeneity;
        
        kelas(j+countdata*(i-1)) = i;
    end
    cd('..');
end
cd('..');

save ('features_mat.mat', 'featuresmat');
save ('kelas.mat','kelas');

