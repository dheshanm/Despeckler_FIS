% Takes an input image (HDR) and bins the pixels into 3 and 5 bins, based on its intensity values

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 

inp_img = imread([pthname fname]);
color_img_3 = zeros([size(inp_img) 3],'uint8');
color_img_5 = zeros([size(inp_img) 3],'uint8');

[m, n] = size(inp_img);

tic
i_loop_var = m;
j_loop_var = n;

for i = 1:i_loop_var
    for j = 1:j_loop_var
        pxl_val = getPixel(inp_img, i, j);
        if pxl_val <= 1200
            cat = 1;
            color_img_5(i, j, 1) = 0;
            color_img_5(i, j, 2) = 0;
            color_img_5(i, j, 3) = 0;
        elseif pxl_val <= 2000
            cat = 2;
            color_img_5(i, j, 1) = 255;
            color_img_5(i, j, 2) = 0;
            color_img_5(i, j, 3) = 0;
        elseif pxl_val <= 3000
            cat = 3;
            color_img_5(i, j, 1) = 0;
            color_img_5(i, j, 2) = 255;
            color_img_5(i, j, 3) = 0;
        elseif pxl_val <= 5000
            cat = 4;
            color_img_5(i, j, 1) = 0;
            color_img_5(i, j, 2) = 0;
            color_img_5(i, j, 3) = 255;
        else
            cat = 5;
            color_img_5(i, j, 1) = 255;
            color_img_5(i, j, 2) = 255;
            color_img_5(i, j, 3) = 255;
        end
        
        if pxl_val <= 1200
            cat = 1;
            color_img_3(i, j, 1) = 255;
            color_img_3(i, j, 2) = 0;
            color_img_3(i, j, 3) = 0;
        elseif pxl_val <= 3000
            cat = 2;
            color_img_3(i, j, 1) = 0;
            color_img_3(i, j, 2) = 255;
            color_img_3(i, j, 3) = 0;
        else
            cat = 3;
            color_img_3(i, j, 1) = 0;
            color_img_3(i, j, 2) = 0;
            color_img_3(i, j, 3) = 255;
        end
    end
end
toc

figure('Name','RGB', 'NumberTitle','off')
ax1 = subplot(1,1,1); imshow(color_img_3);
figure('Name','BRGBW', 'NumberTitle','off')
ax2 = subplot(1,1,1); imshow(color_img_5);

linkaxes([ax1 ax2],'xy');

figure
histogram(inp_img)
figure
imhist(color_img_5)


function pixel = getPixel(mat, i, j)
    pixel = mat(i, j);
end