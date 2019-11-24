import numpy as np
from imgaug import augmenters as iaa
from imgaug.augmentables.bbs import BoundingBox, BoundingBoxesOnImage


def imgaug(images, heatmaps=None, segmentation_maps=None, keypoints=None, bounding_boxes=None, polygons=None, transforms=None):
    seq = iaa.Sequential()
    if transforms is None:
        transforms = []
    for transform in transforms:
        f = transform.get("f", "Noop")
        sometimes = transform.get("sometimes", 1)
        transform.pop('f', None)
        transform.pop('sometimes', None)
        augm = getattr(iaa, f)(**transform)
        seq.add(iaa.Sometimes(sometimes, augm))
    result = seq.augment(images=images, heatmaps=heatmaps, segmentation_maps=segmentation_maps, bounding_boxes=bounding_boxes, keypoints=keypoints, polygons=polygons)
    result = tuple([res for res in result if res is not None])
    if len(result) == 1:
        return result[0]
    else:
        return result
