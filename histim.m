% Script to diplat the histogram of an Image

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 

img = imread([pthname fname]);
[m, n] = size(img);

figure
histogram(img)

%