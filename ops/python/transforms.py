import numpy as np
from imgaug import augmenters as iaa


def imgaug(img, transform, sometimes=1, **kwargs):
    iaa_fun = iaa.Sometimes(sometimes, getattr(iaa, transform)(**kwargs))
    return iaa_fun.augment_image(img)
