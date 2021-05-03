from PIL import Image, UnidentifiedImageError
from pathlib import Path
from glob import glob
import numpy as np
import os
import argparse
import cv2 as cv
import ntpath
import pandas as pd 
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import peak_signal_noise_ratio as psnr

parser = argparse.ArgumentParser(description='Script to compute speckle metrics for image pairs')
parser.add_argument('--noisy-dir', dest='noisy_dir', help='Path to the noisy(with speckles) images directory to be considered')
parser.add_argument('--filtered-dir', dest='filtered_dir', help='Path to the filtered(without speckles) images directory to be considered')
parser.add_argument('--img-ext', dest='ext', help='Extension of the Images to be considered')
# parser.add_argument('--noisy', dest='noisy', help='Path to the noisy(with speckles) image to be considered')
# parser.add_argument('--filtered', dest='filtered', help='Path to the filtered(without speckles) image to be considered')
args = parser.parse_args()

def SSI(noisy, filtered):
    """ Speckle Suppression Index """
    sigma_r = np.std(filtered)
    r_dash = np.mean(filtered)

    sigma_f = np.std(noisy)
    f_dash = np.mean(noisy)
    
    SSI = (sigma_r * f_dash) / (r_dash * sigma_f)
    print(f'        [*] SSI @ {SSI}')
    return SSI

def ENL_handler(path):
    img_f_raster = Image.open(path).convert('L')
    
    # Setting the points for cropped image 
    left = 8000
    top = 8000
    right = 10000
    bottom = 10000
    
    f_crop = img_f_raster.crop((left, top, right, bottom)) 
    
    save_path = os.path.join(os.path.join(os.path.join(os.path.join(os.getcwd(), 'output'), 'metrics'), 'enl'), ntpath.basename(noisy_files[idx]))
    f_crop.save(save_path) 
    
    return ENL(np.asarray(f_crop))
    
def ENL(filtered):
    """ Equivalent Number of Looks """
    mu = np.mean(filtered)
    sigma = np.std(filtered)

    ENL = (mu / sigma)**2
    print(f'        [*] ENL @ {ENL}')
    return ENL

def SMPI(noisy, filtered):
    """ Speckle Suppression and Mean Preservation Index """
    sigma_r = np.std(filtered)
    r_dash = np.mean(filtered)

    sigma_f = np.std(noisy)
    f_dash = np.mean(noisy)

    Q = 1 + abs(f_dash - r_dash)

    SMPI = Q * (sigma_r / sigma_f)
    print(f'        [*] SMPI @ {SMPI}')
    return SMPI
    
def SSIM(img_n, img_f):
    SSIM = ssim(img_f, img_n, data_range=max(img_f.max(), img_n.max()) - min(img_f.min(), img_n.min()))
    print(f'        [*] SSIM @ {SSIM}')
    return SSIM
    
def PSNR(img_n, img_f):
    PSNR = psnr(img_f, img_n, data_range=max(img_f.max(), img_n.max()) - min(img_f.min(), img_n.min()))
    print(f'        [*] PSNR @ {PSNR}')
    return PSNR
    
def MEAN_in(img_n):
    MEAN = np.mean(img_n)
    print(f'        [*] MEAN Input @ {MEAN}')
    return MEAN
    
def MEAN_out(img_n):
    MEAN = np.mean(img_n)
    print(f'        [*] MEAN Output @ {MEAN}')
    return MEAN
    

if __name__ == '__main__':
    df = pd.DataFrame(columns = ['Name', 'PSNR', 'SSI', 'SMPI', 'SSIM', 'MEAN_in', 'MEAN_out']) 
    noisy_files = glob((args.noisy_dir+'/*.'+args.ext).format('float32'))
    denoi_files = glob((args.filtered_dir+'/*.'+args.ext).format('float32'))
    print(f' [] Found {len(noisy_files)} files')
    print(f'[*] Computing Metrics')
    print(f'    [] Overridding PILs DecompressionBombError')
    Image.MAX_IMAGE_PIXELS = None  # Override PIL's DecompressionBombError
    
#     print(f'    [] Loading Noisy Image @ {args.noisy}')
#     img_n = np.asarray(Image.open(args.noisy).convert('L'))  # Noisy
#     print(f'    [] Loading Filtered Image @ {args.filtered}')
#     img_f = np.asarray(Image.open(args.filtered).convert('L'))  # Filtered
#     print(f'[*] Starting Metrics Computation')
    
    for idx in range(len(noisy_files)):
        print(f'    [ {idx+1} / {len(noisy_files)} ] Loading Noisy Image @ {noisy_files[idx]}')
        img_n = np.nan_to_num(np.asarray(Image.open(noisy_files[idx])), posinf=46000, neginf=0)  # Noisy
        print(f'    [ {idx+1} / {len(noisy_files)} ] Loading Filtered Image @ {denoi_files[idx]}')
        img_f = np.nan_to_num(np.asarray(Image.open(denoi_files[idx])), posinf=46000, neginf=0)  # Filtered
        # print(f'    [] Clipping Images to range 0 to 46000')
        # np.clip(img_n, 0, 46000, img_n)
        # np.clip(img_f, 0, 46000, img_f)
        
    ###########################################################################
        print(f'      [*] Starting Metrics Computation')
        psnr_v = PSNR(img_n, img_f)
        ssi_v = SSI(img_n, img_f)
        smpi_v = SMPI(img_n, img_f)
#         enl_v = ENL_handler(denoi_files[idx])
        mean_in = MEAN_in(img_n)
        mean_out = MEAN_out(img_f)
        # ssim_v = SSIM(img_n, img_f)

#         df = df.append({'Name' : ntpath.basename(noisy_files[idx]), 'PSNR' : psnr_v, 'SSI' : ssi_v, 'SMPI': smpi_v, 'ENL': enl_v}, ignore_index = True) 
        # df = df.append({'Name' : ntpath.basename(noisy_files[idx]), 'PSNR' : psnr_v, 'SSI' : ssi_v, 'SMPI': smpi_v, 'SSIM': ssim_v, 'MEAN_in': mean_in, 'MEAN_out': mean_out}, ignore_index = True)
        
        df = df.append({'Name' : ntpath.basename(noisy_files[idx]), 'PSNR' : psnr_v, 'SSI' : ssi_v, 'SMPI': smpi_v, 'MEAN_in': mean_in, 'MEAN_out': mean_out}, ignore_index = True) 
    
    ###########################################################################
    
    # df.to_csv(os.path.join(os.path.join(os.getcwd(), 'output'), 'metrics.csv'), index = False)
    df.to_csv(os.path.join(args.filtered_dir, 'metrics.csv'), index = False)
    print(f'[*] Script Succeeded')