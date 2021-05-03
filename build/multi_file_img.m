[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image', 'MultiSelect', 'on'); %select image 
num_of_files = size(fname);
num_of_files = num_of_files(2);
fprintf('# of Files : %d\n', num_of_files)

[fis_fname, fis_pthname]=uigetfile('*.fis','Select the FIS'); %select FIS 
fprintf('Reading FIS: %s\n', [fis_pthname, fis_fname])

for idx = 1:num_of_files
    img_fname_path = fname{idx};
    fprintf('Opening file: %s\n', [pthname, img_fname_path])
    img = imread([pthname img_fname_path]);
    
    [exec_time, img_processed] = driver_c_v2(img, [fis_pthname, fis_fname]);
    fprintf('Process Completed in: %fs\n', exec_time)
    
    out_fname = sprintf('D:/dev/SAR/matlab/Despeckler_FIS/data/Output/HDR/Suppression/out_v4_%s', img_fname_path);
    info = imfinfo([pthname img_fname_path]);
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
end
