using YAML
using Distributed


function one_hot(data; classes)
    img, label = data
    onehot = zeros(length(classes))
    onehot[label+1] = 1
    return (img, onehot), 1
end
