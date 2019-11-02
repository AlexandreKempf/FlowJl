using YAML
using Distributed
using FileIO


function one_hot(label; classes)
    onehot = zeros(length(classes))
    onehot[label+1] = 1
    return onehot
end

function replace(path::AbstractString; old::AbstractString, new:: AbstractString)
    return Base.replace(path, old => new)
end
