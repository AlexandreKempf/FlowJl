[![TODO board](https://imdone.io/api/1.0/projects/5d9f46efb667c06aa78184ff/badge)](https://imdone.io/app#/board/AlexandreKempf/FlowJl)

# FlowJl

## Description

## Should I use FlowJl ?

## Installation

## Get Started

## Features
- subflows
- kwargs in parents >> kwargs in children
- operator return nothing handled
- map for loop over args for function and subflows

## TODO

- [x] handle Python operators
- [x] handle loop on all args, not on kwargs
- [x] generalized the imgaug with bounding boxs, labels ...
- [x] save config
- [x] handle no output for a block or a flow
- [x] save, replace ... make them usable despite the interference (use Base.replace in the replace function ?)

- [ ] implement dataset and imgaug on dataset for training
- [ ] implement dataloader for training
- [ ] implement validation set
- [ ] generate dataset easily to test models (MNIST, iris, ...)
- [ ] test and generate a few models
- [ ] change dimensions of images for python operators
- [ ] define types for datasets, images ...
- [ ] overwrite function save, load ... based on type
- [ ] parallel loop for the map
- [ ] test imgaug with bounding boxs, labels ...
- [ ] save git reference in json
- [ ] create a mongodb to store experiments
- [ ] docker everything
