% Precess an Image through a FIS
[fname, pthname] = uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); % select image 
fprintf('[%s] Opening file: %s\n', datetime('now'), [pthname, fname])
img = imread([pthname fname]);


[fis_fname, fis_pthname] = uigetfile('*.fis','Select the FIS'); % select image 
fprintf('[%s] Reading FIS: %s\n', datetime('now'), [fis_pthname, fis_fname])
% fis_fname = 'low_intensity.fis';
% fis = readfis([fis_pthname fis_fname]);

out_dir = uigetdir('', 'Select Output Directory');

[exec_time, img_processed] = driver_c_v2(img, [fis_pthname, fis_fname]);
fprintf('[%s] Process Completed in: %fs\n', datetime('now'), exec_time)

out_fname = sprintf('%s\\sug_5_%s', out_dir, fname);
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
