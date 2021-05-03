% Precess an Image through a FIS
fprintf('Reading Image: %s\n', 'D:\dev\SAR\matlab\Despeckler_FIS\data\Tile\output_19648311_RH_0_0\19648311_RH_0_0_0_0.tif')
img = imread('D:\dev\SAR\matlab\Despeckler_FIS\data\Tile\output_19648311_RH_0_0\19648311_RH_0_0_0_0.tif');

fprintf('Reading FIS: %s\n', 'D:\dev\SAR\matlab\Despeckler_FIS\suppression_hdr_v3.fis')
fis = readfis('D:\dev\SAR\matlab\Despeckler_FIS\suppression_hdr_v3.fis');

[exec_time, img_processed] = driver(img, [fis_pthname, fis_fname]);