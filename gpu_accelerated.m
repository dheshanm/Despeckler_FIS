% Precess an Image through a FIS
[fname, pthname] = uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); % select image 
fprintf('Opening file: %s\n', [pthname, fname])

img = imread([pthname fname]);
% figure
% imshow(img); % Display Image

[fis_fname, fis_pthname] = uigetfile('*.fis','Select the FIS'); % select image 
% fis_fname = 'low_intensity.fis';
fprintf('Reading FIS: %s\n', [fis_pthname, fis_fname])
fis = readfis([fis_pthname fis_fname]);

[m, n] = size(img);
img_pad = padarray(img,[1 1]);
img_pad = gpuArray(img_pad);
img_out = gpuArray(img);

tic
numCores = feature('numcores');
poolobj = parpool(numCores-3);
% poolobj = parpool(4);
i_loop_var = m-1;
j_loop_var = n-1;

pctRunOnAll warning off

numIterations = i_loop_var-1;
ppm = ParforProgressbar(numIterations, 'showWorkerProgress', true);

parfor i = 2:i_loop_var
    for j = 2:j_loop_var
        mat = getWindow(img_pad, i, j); % selecting your 3x3 window
        arr = reshape(mat, [1 numel(mat)]); %convert to 1-D array
        arr = gather(arr);
        arr = cast(arr,'double');
        img_out(i,j) = evalfis(fis,arr); %replaced with corrections
    end
    ppm.increment();
end

% Delete the progress handle when the parfor loop is done (otherwise the 
% timer that keeps updating the progress might not stop).
delete(ppm);
delete(poolobj)
toc

img_out = gather(img_out);

figure
imhist(img) % Display Image Histogram
hold on
imhist(img_out)

% figure
% ax1 = subplot(1,1,1); imshow(img);
% figure
% ax2 = subplot(1,1,1); imshow(img_out);

% linkaxes([ax1 ax2],'xy');

out_fname = sprintf('data/Output/HDR/Suppression/out_v3_none_%s', fname);
% out_fname = sprintf('data/Output/HDR/out_%s', fname);
% imwrite(img_out, out_fname); % Save output Image

info = imfinfo([pthname fname]);
t = Tiff(out_fname, 'w');
tagstruct.ImageLength = size(img_out, 1);
tagstruct.ImageWidth = size(img_out, 2);
tagstruct.Compression = Tiff.Compression.None;
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = info.BitsPerSample; % 32;
tagstruct.SamplesPerPixel = info.SamplesPerPixel; % 1;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
t.setTag(tagstruct);
t.write(img_out);
t.close();

function window = getWindow(mat, i, j)
    window = mat(i-1:i+1,j-1:j+1);
end