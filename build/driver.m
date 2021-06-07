function [exec_time, img_processed] = driver(img, fis_path)
%MAIN Precess an Image through a FIS
%coder.extrinsic('evaluatefis_mex');

[m, n] = size(img);
img_pad = padarray(img,[1 1]);
img_out = img;

fis = getFISCodeGenerationData(fis_path);

fprintf('Starting Process...\n');
tic

i_loop_var = m-1;
j_loop_var = n-1;

parfor i = 2:i_loop_var
    for j = 2:j_loop_var
            mat = getWindow(img_pad, i, j); % selecting your 3x3 window
            arr = reshape(mat, [1 numel(mat)]); %convert to 1-D array
            arr = cast(arr,'double');
            img_out(i,j) = evaluatefis(fis, arr); %replaced with corrections
    end
end

exec_time = toc;

img_processed = img_out;
end

function window = getWindow(mat, i, j)
    window = mat(i-1:i+1,j-1:j+1);
end

function y = evaluatefis(fis, x)
    %#codegen
    y = evalfis(fis,x);
    y = y(1);
end

