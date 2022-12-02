%Training

% Mencari lokasi dataset
cd('FruitsData');
% Nama masing-masing folder
fruitdata = {'apple';'banana';'orange';'melon';'pear'};
% Menghitung kategori buah yang di training
countfruit = length(fruitdata);
for i = 1:countfruit
    cd(char(fruitdata(i)));
    citradata = dir('*jpg');
    countdata = length(citradata);
    % Menghitung jumlah buah pada masing-masing kategori
    for j=1:countdata
        filename = citradata(j).name;
        % Mengubah citra menjadi grey scale
        if size(imread(filename),3) == 1
            xcitra = imread(filename);
        else
            xcitra = rgb2gray(imread(filename));
        end
        % Menggunakan pendekatan GLCM
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

% Menyimpan matrix GLCM dan kelas agar tidak dilakukan training berulang
% kali
save ('features_mat.mat', 'featuresmat');
save ('kelas.mat','kelas');

