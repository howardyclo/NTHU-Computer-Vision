""" Data utils """

import numpy as np

from skimage.io import imread, imshow, imsave
from skimage.filters import threshold_adaptive
from skimage.morphology import disk
from skimage.filters.rank import median

# convert face to edge
# currently only support grayscale image read from skimage.io.imread
def face2edge(im_face):
    contrast = threshold_adaptive(im_face, block_size=151, method='gaussian', offset=30) # high-contrast
    im_edge = median(contrast, disk(1.4)) # denoise
    return im_edge

# normalize image from [0,255] to [-1,1]
def normalize(image):
    return (image / 127.5) - 1.0

# inverse normalize image from [-1,1] to [0,1]
def inv_normalize(image):
    return (image + 1.0) / 2.0

def load_data(image_path):
    image = imread(image_path)
    image_width = image.shape[1]

    image_A = image[:, 0:image_width/2]
    image_B = image[:, image_width/2:image_width]

    image_A = normalize(image_A)
    image_B = normalize(image_B)

    if image.ndim == 2:
        image_A = image_A[:, :, np.newaxis]
        image_B = image_B[:, :, np.newaxis]

    image_AB = np.concatenate([image_A, image_B], axis=2)

    return image_AB

def merge(images, size):
    h, w = images.shape[1], images.shape[2]
    img = np.zeros((h * size[0], w * size[1], 3))
    for idx, image in enumerate(images):
        i = idx % size[1]
        j = idx // size[1]
        img[j*h:j*h+h, i*w:i*w+w, :] = image

    return img

def save_images(images, size, image_path):
    image = merge(inv_normalize(images), size)
    return imsave(image_path, image)
