# Notes for running and configuring darknet
- Notes for testing YOLOv4 in a containerized environment
- The documentation for configuring YOLO can be found [here](https://github.com/AlexeyAB/darknet#how-to-train-to-detect-your-custom-objects).
- Pre-trained weights for YOLOv4 can be found from [here](https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137).
## Descriptions of files
- `cfg/yolov4-obj.cfg` - network configuration.
- `data/obj.names` - class names.
- `data/obj.data` - training data configurations.
- `data/train-obj.txt` - list of training files.
- `valid-obj.txt` - list of validation files.
- `data/obj`-folder contains images and annotations.
- `yolov4.conv.137` or `*.weights` - pre-trained weights.


## Copy configuration new TODO MAKE REDUNDANT
```bash
cd darknet
cp -r ../shared/training/data .                    # Training dataset configuration
cp -r ../shared/training/cfg/yolov4-obj.cfg ./cfg/ # Network configuration
```



# Training examples

Begin training with pre-trained weights
```bash
./darknet detector train data/obj.data cfg/yolov4-obj.cfg yolov4.conv.137 -map -dont_show
```

Continue training with latest weights
```bash
./darknet detector train data/obj.data cfg/yolov4-obj.cfg ../shared/weights/yolov4-obj_last.weights
```

# Object detection examples
```bash
./darknet detector test data/obj.data cfg/yolov4-obj.cfg ../shared/weights/yolov4-obj_best_210521.weights ../shared/training/data/obj/1c2d9660bdc7a6df0ffcf8b692357fa5.png -thresh 0.1 -dont_show
```


# Pseudo-labeling
Process a list of images and save list of results in YOLO format into `<image_name>.txt` for each image.
```bash
./darknet detector test data/obj.data cfg/yolov4-obj.cfg ../shared/weights/yolov4-obj_best_210521.weights -thresh 0.3 -dont_show -save_labels < ../shared/weights/new_train.txt
```