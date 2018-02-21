import numpy
import cv2

img = numpy.zeros((512, 512, 3), numpy.uint8)

img = cv2.rectangle(img, (384,0), (510,128), (0,255,0), 3)
