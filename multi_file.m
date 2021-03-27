% Multi-file processing for FIS

[fname, pthname]=uigetfile('*.jpg;*.png;*.tif;*.bmp','Select the Asset Image', 'MultiSelect', 'on'); %select image 
num_of_files = size(fname);
num_of_files = num_of_files(2);

[fis_fname, fis_pthname]=uigetfile('*.fis','Select the FIS'); %select image 
% fis_fname = 'low_intensity.fis';
fis = readfis([fis_pthname fis_fname]);

poolobj = parpool(6);
pctRunOnAll warning off

for idx = 1:num_of_files
    img_fname = fname{idx};
    img = imread([pthname img_fname]);

    [m, n] = size(img);
    img_pad = padarray(img,[1 1]);
    img_out = img;

    tic
    i_loop_var = m-1;
    j_loop_var = n-1;

    numIterations = i_loop_var-1;
    ppm = ParforProgressbar(numIterations, 'showWorkerProgress', true);

    parfor i = 2:i_loop_var
        for j = 2:j_loop_var
            mat = getWindow(img_pad, i, j); % selecting your 3x3 window
            arr = reshape(mat, [1 numel(mat)]); %convert to 1-D array
            arr = cast(arr,'double');
            img_out(i,j) = evalfis(fis,arr); %replaced with corrections
        end
        ppm.increment();
    end

    % Delete the progress handle when the parfor loop is done (otherwise the timer that keeps updating the progress might not stop).
    delete(ppm);
    toc

    % figure
    % imhist(img) % Display Image Histogram
    % hold on
    % imhist(img_out)

    % figure
    % ax1 = subplot(1,1,1); imshow(img);
    % figure
    % ax2 = subplot(1,1,1); imshow(img_out);
    % 
    % linkaxes([ax1 ax2],'xy');

    out_fname = sprintf('data/speckle/output/low_intensity/out_%s', img_fname);
    imwrite(img_out, out_fname); % Save output Image
end
delete(poolobj)

function window = getWindow(mat, i, j)
    window = mat(i-1:i+1,j-1:j+1);
end