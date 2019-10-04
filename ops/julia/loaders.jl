using YAML

"""
    load_data(path::AbstractString):: Vector{Tuple{Any, Any}}

Load a dataset in `path` and return a Vector of Tuple{data, label}
"""
function load_data(path)
    data = YAML.load(open(path));
    inputs = get(data, "inputs", []);
    root = get(data, "root", "");
    labels = get(data, "labels", repeat([nothing], length(inputs)));
    classes = get(data, "classes", []);
    return [el for el in zip(inputs, labels)], classes
end

function return_int(int)
    return int
end
