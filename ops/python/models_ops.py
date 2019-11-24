import torch.optim as optim
import torch.optim.lr_scheduler as sched
import torch.nn as nn
import torch
from .VGG import VGGobj
from warmup_scheduler import GradualWarmupScheduler


def VGG(blueprint, classes, batch_norm=True, weights=None, channels=3):
    init_weights = True
    if weights is not None:
        init_weights = False
    nb_classes = len(classes)
    vgg = VGGobj(blueprint, channels, batch_norm, nb_classes, init_weights)
    if weights is not None:
        vgg.load_state_dict(torch.load(weights))
    return vgg


def fit(model, data, optimizer, scheduler, loss, augmentation, parameters):

    model = model.train()

    optimizer_fun = getattr(optim, optimizer['name'])(model.parameters(), **optimizer)
    scheduler_fun = getattr(optim, scheduler['name'])(optimizer, **scheduler)
    loss_fun = getattr(nn, loss['name'])(**loss)


    if scheduler.get("warmup", None) is not None:
        nb_epoch_warmup = int(parameters['epoch'] * scheduler["warmup"])
        optimizer_fun.defaults['lr'] *= 0.01
        scheduler_fun = GradualWarmupScheduler(optimizer_fun, multiplier=100, total_epoch=nb_epoch_warmup, after_scheduler=scheduler_fun)


    for ep in range(parameters['epoch']):  # loop over the dataset multiple times
        running_loss = 0.0
        for i, d in enumerate(data):
            # get the inputs; d is a list of [inputs, labels]
            inputs, labels = d

            # zero the parameter gradients
            optimizer.zero_grad()

            # forward + backward + optimize
            outputs = model(inputs)
            loss_measure = loss_fun(outputs, labels)
            loss_measure.backward()
            optimizer.step()
            scheduler.step()

            # print statistics
            running_loss += loss_measure.item()
            if i % 10 == 0:    # print every 10 mini-batches
                print('[%d, %5d] loss: %.3f' %
                      (ep + 1, i + 1, running_loss / 10))
                running_loss = 0.0
            print('Finished Training')
    return model


def evaluate(model, data, criterion):
    model = model.eval()
    outputs = []
    for i, d in enumerate(data):
        inputs, labels = d
        # forward + backward + optimize
        outputs.append(model(inputs))
    return outputs


# def predict(model, data, criterion):
#     model = model.eval()
#     outputs = []
#     for i, d in enumerate(data):
#         inputs, labels = d
#         # forward + backward + optimize
#         outputs.append(model(inputs))
#     return outputs



# PICK BEST
# SAVE MODEL
# LOAD MODEL

# CREATE DATACONTAINER FROM BATCH OR LIST
# SAVE DATACONTAINER
# LOAD DATACONTAINER
