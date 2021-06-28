function [exec_time, img_processed] = driver_gui(img_path, fis_path, out_path)
% driver_gui Processes the Image in 'img_path' using the FIS in 'fis_path'
% and outputs the image to 'out_path'

fprintf('[%s] Opening file: %s ', datetime('now'), img_path)
img = imread(img_path);
fprintf('...done \n')

fprintf('[%s] Using FIS: %s\n', datetime('now'), fis_path)

fprintf('[%s] Output Directory: %s\n', datetime('now'), out_path)

[exec_time, img_processed] = driver_trim_mex_c(img, fis_path);

info = imfinfo(img_path);
t = Tiff(out_path, 'w');
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

fprintf('Output: %s\n', out_path)
end