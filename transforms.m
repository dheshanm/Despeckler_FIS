% Performs Logrithmic and Exponential Transforms on an Image
[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 

img = imread([pthname fname]);

[row, col, wid] = size(img);
if(wid==3)
    img = rgb2gray(img); % convert to gray scale if it is color image
end

c = 2;

% Log transformation
L = img;
for i=1:size(img,1)
    for j=1:size(img,2)
        in = double(img(i,j));
        L(i,j) = c.*log10(in);
    end
end

% Exponantial transformation
E = img;
for i=1:size(img,1)
    for j=1:size(img,2)
        in = double(L(i,j));
        E(i,j) = exp(in);
    end
end

% convert to 8-bit
logT = (L/(max(L(:))))*255;
expT = (E/(max(E(:))))*255;

figure
ax1 = subplot(1,1,1); imshow(img),title('Original');
figure
% ax2 = subplot(1,1,1); imshow(logT),title('Log Transformed');
ax2 = subplot(1,1,1); imshow(L),title('Log Transformed');
figure
% ax3 = subplot(1,1,1); imshow(expT),title('Exponential of Log Transformed');
ax3 = subplot(1,1,1); imshow(E),title('Exponential of Log Transformed');

linkaxes([ax1 ax2 ax3],'xy');