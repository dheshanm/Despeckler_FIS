% Takes a HDR image and another HDR image, bins their pixels into 3, based on
% their intensity values, and opens a windows with linked axes to compare
% the same.

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Input HDR Image'); %select image 
hdr_inp_img = imread([pthname fname]);

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Output HDR Image'); %select image 
hdr_out_img = imread([pthname fname]);

color_img_hdr_inp = zeros([size(hdr_inp_img) 3],'uint8');
color_img_hdr_out = zeros([size(hdr_out_img) 3],'uint8');

[m, n] = size(hdr_inp_img);

tic
i_loop_var = m;
j_loop_var = n;

for i = 1:i_loop_var
    for j = 1:j_loop_var
        pxl_val = getPixel(hdr_inp_img, i, j);
        if pxl_val <= 1200
            cat = 1;
            color_img_hdr_inp(i, j, 1) = 255;
            color_img_hdr_inp(i, j, 2) = 0;
            color_img_hdr_inp(i, j, 3) = 0;
        elseif pxl_val <= 3000
            cat = 2;
            color_img_hdr_inp(i, j, 1) = 0;
            color_img_hdr_inp(i, j, 2) = 255;
            color_img_hdr_inp(i, j, 3) = 0;
        else
            cat = 3;
            color_img_hdr_inp(i, j, 1) = 0;
            color_img_hdr_inp(i, j, 2) = 0;
            color_img_hdr_inp(i, j, 3) = 255;
        end
        
        pxl_val = getPixel(hdr_out_img, i, j);
        if pxl_val <= 1200
            cat = 1;
            color_img_hdr_out(i, j, 1) = 255;
            color_img_hdr_out(i, j, 2) = 0;
            color_img_hdr_out(i, j, 3) = 0;
        elseif pxl_val <= 3000
            cat = 2;
            color_img_hdr_out(i, j, 1) = 0;
            color_img_hdr_out(i, j, 2) = 255;
            color_img_hdr_out(i, j, 3) = 0;
        else
            cat = 3;
            color_img_hdr_out(i, j, 1) = 0;
            color_img_hdr_out(i, j, 2) = 0;
            color_img_hdr_out(i, j, 3) = 255;
        end
    end
end
toc

% figure
% ax1 = subplot(1,3,1); imshow(color_img_3);
% ax2 = subplot(1,3,2); imshow(color_img_5);
% ax3 = subplot(1,3,3); imshow(inp_img);
% linkaxes([ax1 ax2 ax3],'xy');

figure('Name','Input', 'NumberTitle','off')
ax1 = subplot(1,1,1); imshow(color_img_hdr_inp);
figure('Name','Output', 'NumberTitle','off')
ax2 = subplot(1,1,1); imshow(color_img_hdr_out);
linkaxes([ax1 ax2],'xy');

% figure
% histogram(inp_img)
% out_fname_3 = sprintf('data/output/color/color_%s', fname);
% imwrite(color_img_hdr, out_fname_3); % Save output Image

function pixel = getPixel(mat, i, j)
    pixel = mat(i, j);
end