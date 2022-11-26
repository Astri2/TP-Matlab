clear all;
close all;

load('LungCut.mat');

subplot(2,6,1);
imshow(Im);
subplot(2,6,7);
hist(Im);


Im2 = Im*2;

subplot(2,6,2);
imshow(Im2);
subplot(2,6,8);
hist(Im2)


Im3 = Im2 < SeuilOptimal(Im2);

subplot(2,6,3);
imshow(Im3)


SE = strel('disk',2);
Im4 = imopen(imclose(Im3,SE),SE);

subplot(2,6,4);
imshow(Im4)


A = regionprops(Im4,'Centroid','Area','PixelIdxList');
segm=segmentation(A);
Im5 = ones(size(Im));
Im5(segm) = 0;

subplot(2,6,5)
imshow(Im5)


[x, y] = point_ref(Im5);
Im6 = regiongrowing(Im,x,y,0.15);

subplot(2,6,6)
imshow(Im6)