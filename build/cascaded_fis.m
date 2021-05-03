[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 
fprintf('[%s] Opening file: %s\n', datetime('now'), [pthname, fname])
img = imread([pthname fname]);

[fis_fname_1, fis_pthname_1]=uigetfile('*.fis','Select the FIS1'); %select FIS 
fprintf('[%s] Reading FIS1: %s\n', datetime('now'), [fis_pthname_1, fis_fname_1])

[fis_fname_2, fis_pthname_2]=uigetfile('*.fis','Select the FIS2'); %select FIS 
fprintf('[%s] Reading FIS2: %s\n', datetime('now'), [fis_pthname_2, fis_fname_2])

fprintf('[%s] Starting FIS1 Process...\n', datetime('now'))
[exec_time, img_processed] = driver_c_v2(img, [fis_pthname_1, fis_fname_1]);
fprintf('[%s] Process Completed in: %fs\n', datetime('now'), exec_time)

fprintf('[%s] Starting FIS2 Process...\n', datetime('now'))
[exec_time, img_processed] = driver_c_v2(img_processed, [fis_pthname_2, fis_fname_2]);
fprintf('[%s] Process Completed in: %fs\n', datetime('now'), exec_time)
    
out_fname = sprintf('data/Output/cfis_%s', fname);
fprintf("Output: %s\n", out_fname);
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
