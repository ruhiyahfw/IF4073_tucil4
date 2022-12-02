classdef ImageProcessingClassifier
    methods (Static)
        function [klasifikasi] = predict(img)
            % Load matrix training
            filefeatures = load("features_mat.mat");
            featuresmat = filefeatures.featuresmat;
            filekelas = load('kelas.mat');
            kelas = filekelas.kelas;
            % Menggunakan metode KNN dengan machine learning
            model = fitcknn(featuresmat,kelas');
            if Helper.isGrayscale(img)
                m = graycomatrix(img);
            else
                m = graycomatrix(rgb2gray(img));
            end
            g = graycoprops(m);
            uji(1,1) = g.Contrast;
            uji(1,2) = g.Correlation;
            uji(1,3) = g.Energy;
            uji(1,4) = g.Homogeneity;
            % Melakukan prediksi berdasarkan kesamaan kontras, korelasi,
            % entropi, dan homogeneity
            klasifikasi = predict(model,uji(1,:));
        end
    end
end