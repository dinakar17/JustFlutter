import os
os.add_dll_directory("C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v11.2/bin")

from flask import Flask
import tensorflow.compat.v2 as tf

# import tensorflow as tf

# physical_devices = tf.config.list_physical_devices('GPU')
# print("Num GPUs:", len(physical_devices))

# if tf.test.gpu_device_name(): 

#     print('Default GPU Device: {}'.format(tf.test.gpu_device_name()))

# else:

#    print("Please install GPU version of TF")
import tensorflow_hub as hub

import numpy as np
import pandas as pd
import cv2
from skimage import io

# Loading the model
model = hub.KerasLayer('model')

def predict(imageFile):
    labelmap_url = "labels/aiy_food_V1_labelmap.csv"
    input_shape = (224, 224)

    image = np.asarray(io.imread(imageFile), dtype="float")
    image = cv2.resize(image, dsize=input_shape, interpolation=cv2.INTER_CUBIC)
    # Scale values to [0, 1].
    image = image / image.max()
    # The model expects an input of (?, 224, 224, 3).
    images = np.expand_dims(image, 0)
    # This assumes you're using TF2.
    output = model(images)
    # convert the list into nd array
    nd_output = np.asarray(output[0])
    # pick top 4 maximum valued indices
    top4_indices = np.argpartition(nd_output, -4)[-4:]
    # load all the class names into a list
    classes = list(pd.read_csv(labelmap_url)["name"])
    results = {}
    for idx in top4_indices:
        # {"cake": 0.999}
        # It is important to use float() since float32 is not JSON serializable
        results[classes[idx]] = float(nd_output[idx])
    sorted_results = dict(sorted(results.items(), key=lambda item: item[1], reverse=True))
    return sorted_results


# cake_url = "https://storage.googleapis.com/tfhub-visualizers/google/aiy/vision/classifier/food_V1/1/image_1.jpg"

# print(predict(cake_url))