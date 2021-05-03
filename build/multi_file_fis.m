[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image'); %select image 
fprintf('Opening file: %s\n', [pthname, fname])
img = imread([pthname fname]);

[fis_fname, fis_pthname]=uigetfile('*.fis','Select the FIS', 'MultiSelect', 'on'); %select FIS 
num_of_files = size(fis_fname);
num_of_files = num_of_files(2);
fprintf('# of Files : %d\n', num_of_files)

for idx = 1:num_of_files
    fis_fname_path = fis_fname{idx};
    fprintf('[%s] Reading FIS: %s\n', datetime('now'), [fis_pthname, fis_fname_path])
    
    [exec_time, img_processed] = driver_c_v2(img, [fis_pthname, fis_fname_path]);
    fprintf('[%s] Process Completed in: %fs\n', datetime('now'), exec_time)
    
    out_fname = sprintf('data/Output/out_%s', fis_fname_path);
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
end
