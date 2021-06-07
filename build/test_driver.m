% Precess an Image through a FIS
fprintf('Reading Image: %s\n', 'D:\dev\SAR\matlab\data\full_size\input\HDR\tiled_19648311_RH\19648311_RH_0_3.tif')
img = imread('D:\dev\SAR\matlab\data\full_size\input\HDR\tiled_19648311_RH\19648311_RH_0_3.tif');

fprintf('Reading FIS: %s\n', 'D:\dev\SAR\matlab\Despeckler_FIS\build\sugeno_v2.fis')
fis = readfis('D:\dev\SAR\matlab\Despeckler_FIS\build\sugeno_v2.fis');
path = 'D:\dev\SAR\matlab\Despeckler_FIS\build\sugeno_v2.fis';

[exec_time, img_processed] = driver(img, path);