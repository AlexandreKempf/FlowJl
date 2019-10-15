using YAML
using Distributed


function one_hot(data; classes)
    img, label = data
    onehot = zeros(length(classes))
    onehot[label+1] = 1
    return (img, onehot)
end

function transform(f, args; kwargs...)
    data = []
    for arg in args
        push!(data, f(arg; kwargs...))
    end
    return data
end

data = [(0,1), (0,2)];
cla = [0,1,2,3,4];
transform(one_hot, data; classes=cla)
