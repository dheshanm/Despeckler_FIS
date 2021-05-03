% Script to diplat the histogram of an Image

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 

img = imread([pthname fname]);
[m, n] = size(img);

figure
histogram(img)

limits = quantile(img(:), 3);
r1 = [];
r2 = [];
r3 = [];

tic
i_loop_var = m-1;
j_loop_var = n-1;

for i = 1:i_loop_var
    for j = 1:j_loop_var
        val = img(i, j);
        if val <= limits(1)
            r1 = [r1, val];
        elseif val <= limits(2)
            r2 = [r2, val];
        else
            r3 = [r3, val];
        end
    end
end

% Delete the progress handle when the parfor loop is done (otherwise the 
% timer that keeps updating the progress might not stop).
toc