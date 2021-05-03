import cv2
import math
import os
from tqdm import tqdm

# Source: https://stackoverflow.com/questions/37842476/image-tiling-in-loops-using-python-opencv
# credit: https://stackoverflow.com/users/2561733/telepinu

def ensure_dir(file_path):
    directory = file_path
    if not os.path.exists(directory):
        print('Creading Directory: '+directory)
        os.makedirs(directory)

Path = "19648311_RH_0_0.tif";
filename, file_extension = os.path.splitext(Path)
image = cv2.imread(Path, cv2.IMREAD_ANYDEPTH)
print(Path)

tileSizeX = 32;
tileSizeY = 32;
numTilesX = math.ceil(image.shape[1]/tileSizeX)
numTilesY = math.ceil(image.shape[0]/tileSizeY)

makeLastPartFull = True; # in case you need even siez
out_path = os.path.join(os.getcwd(), 'output_'+filename)
ensure_dir(out_path)

for nTileX in tqdm(range(numTilesX)):
    for nTileY in range(numTilesY):
        startX = nTileX*tileSizeX
        endX = startX + tileSizeX
        startY = nTileY*tileSizeY
        endY = startY + tileSizeY;

        if(endY > image.shape[0]):
            endY = image.shape[0]

        if(endX > image.shape[1]):
            endX = image.shape[1]

        if( makeLastPartFull == True and (nTileX == numTilesX-1 or nTileY == numTilesY-1) ):
            startX = endX - tileSizeX
            startY = endY - tileSizeY

        currentTile = image[startY:endY, startX:endX]
        cv2.imwrite(os.path.join(out_path, filename + '_%d_%d' % (nTileY, nTileX)  + file_extension), currentTile)