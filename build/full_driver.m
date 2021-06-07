% Precess an Image through a FIS
[fname, pthname] = uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); % select image 
fprintf('[%s] Opening file: %s\n', datetime('now'), [pthname, fname])
img = imread([pthname fname]);


[fis_fname, fis_pthname] = uigetfile('*.fis','Select the FIS'); % select image 
fprintf('[%s] Reading FIS: %s\n', datetime('now'), [fis_pthname, fis_fname])
% fis_fname = 'low_intensity.fis';
% fis = readfis([fis_pthname fis_fname]);

[exec_time, img_processed] = my_driver(img, [fis_pthname, fis_fname]);
fprintf('[%s] Process Completed in: %fs\n', datetime('now'), exec_time)

out_fname = sprintf('D:/dev/SAR/matlab/Despeckler_FIS/data/Output/HDR/Sugeno/sug_v2_%s', fname);
% out_fname = sprintf('data/Output/HDR/out_%s', fname);
% imwrite(img_out, out_fname); % Save output Image

info = imfinfo([pthname fname]);
t = Tiff(out_fname, 'w');
tagstruct.ImageLength = size(img_processed, 1);
tagstruct.ImageWidth = size(img_processed, 2);
tagstruct.Compression = Tiff.Compression.None;
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = info.BitsPerSample; % 32;
tagstruct.SamplesPerPixel = info.SamplesPerPixel; % 1;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
t.setTag(tagstruct);
t.write(img_processed);
t.close();

fprintf('Output: %s\n', out_fname)

function [exec_time, img_processed] = my_driver(img, fis_path)
%MAIN Precess an Image through a FIS
%coder.extrinsic('evaluatefis_mex');

[m, n] = size(img);
img_pad = padarray(img,[1 1]);
img_out = img;

fis = getFISCodeGenerationData(fis_path);

fprintf('Starting Process...\n');
tic
numCores = feature('numcores');
poolobj = parpool(numCores-2);  % -2 Not needed for high-core processors
i_loop_var = m-1;
j_loop_var = n-1;

% pctRunOnAll warning off

numIterations = i_loop_var-1;
ppm = ParforProgressbar(numIterations, 'showWorkerProgress', true);

parfor i = 2:i_loop_var
    for j = 2:j_loop_var
        mat = getWindow(img_pad, i, j); % selecting your 3x3 window
        arr = reshape(mat, [1 numel(mat)]); %convert to 1-D array
        arr = cast(arr,'double');
        img_out(i,j) = evaluatefis(fis, arr); %replaced with corrections
    end
    ppm.increment();
end

exec_time = toc;
delete(ppm);
delete(poolobj)
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

