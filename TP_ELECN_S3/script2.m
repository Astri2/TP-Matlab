clc
close all
clear all

% on load les pkg
% pkg load image

% PARTIE 2

ImRGB = imread('neuro.jpeg');

%suppression du canal
ImGray = ImRGB(:,:,1);

%conversion des valeurs en float
ImDouble = double(ImGray);

colormap(gray);
subplot(3,3,1);
imagesc(ImDouble);

% PARTIE 2

maskG = fspecial('gaussian',5,4);
ImGauss = conv2(ImDouble,maskG,'same');

 subplot(3,3,2);
 imagesc(ImGauss);

maskAv = fspecial('average',5);
ImAv = conv2(ImDouble,maskAv, 'same');

 subplot(3,3,3);
 imagesc(ImAv);

% PARTIE 2

maskLap = [0, 1, 0;
           1,-4, 1;
           0, 1, 0];
       
ImLap = conv2(ImGauss,maskLap, 'same');

subplot(3,3,4);
imagesc(ImLap);

ImOut = ImDouble+(0.4.*ImLap);

subplot(3,3,5);
imagesc(ImOut);

figure;
colormap(gray);
subplot(1,2,1);
imagesc(ImDouble);

subplot(1,2,2);
%affichage de la différence entre l'image de base et le laplacien
imagesc(ImOut-ImDouble);

Lena = imread('lena.bmp');
Lena = double(Lena(:,:,1));
LenaNoise = imnoise(Lena, 'gaussian');
LenaGauss = conv2(LenaNoise,maskG,'same');
LenaLap = LenaGauss+0.4.*conv2(LenaGauss,maskLap,'same');

colormap(gray);
subplot(2,2,1);
imagesc(Lena);
axis off
title("Figure 9 :\nLena")
subplot(2,2,2);
imagesc(LenaNoise);
axis off
title("Figure 10 :\nLena avec bruit Gaussien")
subplot(2,2,3);
imagesc(LenaGauss);
axis off
title("Figure 11 :\nLena avec filtre Gaussien");
subplot(2,2,4);
imagesc(LenaLap);
axis off 
title("Figure 12 :\nLena avec filtre Gauss et Laplacien");
saveas(gcf,"t.png");

MY_PSNR1 = mypsnr(255, Lena,LenaGauss);
MY_PSNR2 = mypsnr(255, Lena, LenaLap);

PSNR1 = psnr(Lena, LenaGauss);
PSNR2 = psnr(Lena, LenaLap);
