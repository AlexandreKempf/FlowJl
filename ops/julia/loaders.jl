using YAML
using FileIO
using Images

"""
    load_data(path::AbstractString):: Vector{Tuple{Any, Any}}

Load a dataset in `path` and return a Vector of Tuple{data, label}
"""
function load_data(path)
    data = YAML.load(open(path));
    inputs_raw = get(data, "inputs", []);
    root = get(data, "root", "");
    inputs = [joinpath(root, input_i) for input_i in inputs_raw]
    labels = get(data, "labels", repeat([nothing], length(inputs)));
    classes = get(data, "classes", []);
    return inputs, labels, classes, root
end

function load_img(input)
    img = load(input)
    img = UInt8.(floor.(permutedims(channelview(img), (3,2,1))*255))
    return img
end
