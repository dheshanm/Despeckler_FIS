% Opens up 3 images in their own window with linked axes

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 
img1 = imread([pthname fname]);

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 
img2 = imread([pthname fname]);

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 
img3 = imread([pthname fname]);

figure
ax1 = subplot(1,1,1); imshow(img1);
figure
ax2 = subplot(1,1,1); imshow(img2);
figure
ax3 = subplot(1,1,1); imshow(img3);

linkaxes([ax1 ax2 ax3],'xy');