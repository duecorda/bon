#!/usr/bin/env python

import numpy as np
import cv2
import os, sys
import math
from matplotlib import pyplot as plt

faceHaarPath = os.path.join(os.path.dirname(__file__), 'haarcascade_frontalface_default.xml')
# eyeHaarPath = __path + "/haarcascade_eye_tree_eyeglasses.xml"
eyeHaarPath = os.path.join(os.path.dirname(__file__), 'haarcascade_eye.xml')

face_cascade = cv2.CascadeClassifier(faceHaarPath)
eye_cascade = cv2.CascadeClassifier(eyeHaarPath)

filename = sys.argv[1]
img = cv2.imread(filename)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

height, width, depth = img.shape
matches = []
xs = []
ys = []

matches = face_cascade.detectMultiScale(gray, 1.2, 3)

if len(matches) == 0:
  matches = eye_cascade.detectMultiScale(gray, 1.2, 3)

for (x,y,w,h) in matches:
  xs.append(x)
  ys.append(y)

xs.sort()
ys.sort()

min_x = xs[0] / float(width) * 100
min_y = ys[0] / float(height) * 100

print str(math.ceil(min_x)) + "%",  str(math.ceil(min_y)) + "%"
sys.exit()
# cv2.imshow('img',img)
# cv2.waitKey(0)
# cv2.destroyAllWindows()
