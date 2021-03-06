# Notes for running and configuring darknet
- The full documentation for configuring YOLO can be found [here](https://github.com/AlexeyAB/darknet#how-to-train-to-detect-your-custom-objects).
- Pre-trained weights for YOLOv4 (COCO, 80 classes) can be found from [here](https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.conv.137).
- The weights for the example network which detects dragon heads (1 class) can be found from [here](https://drive.google.com/drive/folders/1-_-UEogMCKSbjYAfzK1_F9Z7aDZLglhJ?usp=sharing).


## Descriptions of files
- `cfg/yolov4-obj.cfg` - network configuration.
- `data/obj.names` - class names.
- `data/obj.data` - training data configurations.
- `data/train-obj.txt` - list of training files.
- `valid-obj.txt` - list of validation files.
-  `yolov4.conv.137` or `*.weights`-files - pre-trained weights.
- `data/obj`-folder contains images and annotations:
  - Annotation file for each image in the same directory, but with `.txt` extension.
  - Bounding box format: `<object-class>` `<x>` `<y>` `<width>` `<height>`
    - `<x>` - center of the bounding box from the left.
    - `<y>` - center of the bounding box from the top.
    - `<width>` - width of the bounding box.
    - `<height>` - height of the bounding box.
    - `NOTE` : Image dimensions are scaled to be from `0` to `1`.


# Example commands
- Assumptions:
  - The commands are to be ran in the container.
  - `container`-folder is mounted as `container/shared` in the container.
  - The weights-file `container/weights/210521_dragon.weights` exists.



## Preparations
Move to the darknet project folder
```
cd darknet
```
Copy the dataset and network configurations (the `obj.data`-file contains hardcoded paths)
```bash
cp -r ../shared/training/data .                    # Training dataset configuration
cp -r ../shared/training/cfg/yolov4-obj.cfg ./cfg/ # Network configuration
```



## Training

Begin training with the pre-trained weights, measure mAP. Checkpoints are created every 100 epochs:
```bash
./darknet detector train data/obj.data cfg/yolov4-obj.cfg ../shared/weights/210521_dragon.weights -map -dont_show
```

## Object detection
Detect objects and output classes and probabilities:
```bash
./darknet detector test data/obj.data cfg/yolov4-obj.cfg ../shared/weights/210521_dragon.weights ../shared/training/data/obj/1c2d9660bdc7a6df0ffcf8b692357fa5.png -thresh 0.1 -dont_show
```


## Pseudo-labeling
Process a list of images and save list of results in YOLO format into `<image_name>.txt` for each image:
```bash
./darknet detector test data/obj.data cfg/yolov4-obj.cfg ../shared/weights/210521_dragon.weights -thresh 0.3 -dont_show -save_labels < ../path/to/image/list/annotate_these.txt
```

## Automation using python-bindings
*WIP, see the `darknet.ipynb`-file.*