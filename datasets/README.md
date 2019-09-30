
root: prefix for all the inputs (not mandatory)
inputs: path to data            (mandatory)
labels: output of the model     (not mandatory)
classes: table refered by labels in classification task (not mandatory)


# Dataset classif simple:
  - root:
    - path/to/dataset
  - inputs: (mandatory)
    - 'id1.png'
    - 'id2.png'
    - 'id3.png'
  - labels:
    - 0
    - 2
    - 1
  - classes:
    - "tiger"
    - "cat"
    - "house"


# Dataset classif multilabel:
  - root:
    - path/to/dataset
  - inputs: (mandatory)
    - 'id1.png'
    - 'id2.png'
    - 'id3.png'
  - labels:
    - [0, 2]
    - [1, 2]
    - [1, 2, 0]
  - classes:
    - "tiger"
    - "cat"
    - "house"


# Dataset regression:
  - root:
    - path/to/dataset
  - inputs: (mandatory)
    - 'id1.png'
    - 'id2.png'
    - 'id3.png'
  - labels:
    - 0.5
    - 1.0
    - 2.1


# Dataset detection:
  - root:
    - path/to/dataset
  - inputs: (mandatory)
    - 'id1.png'
    - 'id2.png'
    - 'id3.png'
  - labels:
    - [[0.5, 0.2, 0.7, 0.5], ...]
    - [[0.5, 0.2, 0.7, 0.5], [0.5, 0.2, 0.7, 0.5]]
    - [[0.5, 0.2, 0.7, 0.5], ...]


# Dataset unsupervised:
  - root:
    - path/to/dataset
  - inputs: (mandatory)
    - 'id1.png'
    - 'id2.png'
    - 'id3.png'
