OPS_PATH = "/home/alex/awesome/FlowJl/ops";
push!(LOAD_PATH, OPS_PATH);
using YAML
using ops
using JSON
using PyCall

# Import operators from python
py"""
import sys
sys.path.insert(0, "/home/alex/awesome/FlowJl/ops")
"""
ops_py = pyimport("ops")



function exec_block(block, ref)
    args = get(block, "args", []);
    args = [ref[k] for k in args];
    kwargs = get(block, "kwargs", Dict());
    kwargs = Dict(if typeof(v)==String && v[1] == ':' Symbol(k) => ref[v[2:end]] else Symbol(k) => v end for (k,v) in kwargs);
    out = get(block, "out", []);
    if endswith(block["f"], ".yaml") # subflow
        result = exec_flow(block["f"], args);
    else
        try # try julia operator
            op = getfield(ops, Symbol(block["f"]));
        catch # try python operator
            op = ops_py[block["f"]]
        end
        result = op(args...; kwargs...)
    end

    if length(out)==1 result=[result] end

    return Dict(out[i] => result[i] for i = 1:length(out));
end


function exec_flow(yaml, args)
    flow = YAML.load(open(yaml));
    subargs = get(flow, "args", []);
    out = get(flow, "out", []);
    ref = Dict(subargs[i] => args[i] for i = 1:length(args));
    ref = merge(ref, get(flow, "kwargs", Dict()));
    for block in flow["flow"]
        subout = exec_block(block, ref);
        ref = merge(ref, subout);
    end
    return [ref[k] for k in out];
end


flowfile = "/home/alex/awesome/FlowJl/flows/example.yaml";
flow = YAML.load(open(flowfile));
a = exec_flow(flowfile, []);
print(a)
