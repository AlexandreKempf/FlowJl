OPS_PATH = "/home/alex/awesome/FlowJl/ops";
push!(LOAD_PATH, OPS_PATH);
using YAML
using ops
using PyCall
using JSON2

# Import operators from python
py"""
import sys
sys.path.insert(0, "/home/alex/awesome/FlowJl/ops")
"""
ops_py = pyimport("ops")

function exec_block(block, ref)
    config = block
    args = get(block, "args", []);
    args = [ref[k] for k in args];
    kwargs = get(block, "kwargs", Dict());
    kwargs = Dict(if typeof(v)==String && v[1] == ':'; k => ref[v[2:end]] else k => v end for (k,v) in kwargs);
    out = get(block, "out", []);
    if block["f"] isa Dict || endswith(block["f"], ".yaml") # subflow
        if block["f"] isa String
            block["f"] = YAML.load(open(block["f"]))
        end
        if get(block, "map", false)
            map_result = []
            for arg in zip(args...)
                result, config["f"] = exec_flow(block["f"], arg, kwargs);
                push!(map_result, result)
            end

            if isempty(out)
                result = []
            else
                if length(out)==1; map_result=[map_result] end
                result = collect(zip(map_result...))
            end
        else
            result, config["f"] = exec_flow(block["f"], args, kwargs);
        end

    else
        try # try julia operator
            global op = getfield(ops, Symbol(block["f"]));
        catch # try python operator
            global op = ops_py[block["f"]];
        end

        kwargs = Dict(Symbol(k) => v for (k, v) in kwargs)

        if get(block, "map", false)
            map_result = []
            for arg in zip(args...)
                push!(map_result, op(arg...; kwargs...))
            end

            if isempty(out)
                result = []
            elseif length(out)==1
                result = map_result
            else
                result = collect(zip(map_result...))
            end;
        else
            result = op(args...; kwargs...);
        end
    end

    if length(out)==1; result=[result] end;
    return Dict(out[i] => result[i] for i = 1:length(out)), config;
end


function exec_flow(flow, global_args=nothing, global_kwargs=nothing)
    global_args === nothing ? global_args = [] : nothing
    global_kwargs === nothing ? global_kwargs = Dict() : nothing
    config = deepcopy(flow)
    config["flow"] = []
    local_args = get(flow, "args", []);
    local_kwargs = get(flow, "kwargs", Dict());
    out = get(flow, "out", []);
    ref = Dict(local_args[i] => global_args[i] for i = 1:length(global_args));
    ref = merge(ref, local_kwargs);
    ref = merge(ref, global_kwargs);
    for block in flow["flow"]
        subout, block_config = exec_block(block, ref);
        push!(config["flow"], block_config)
        ref = merge(ref, subout);
    end
    return [ref[k] for k in out], config;
end

using BenchmarkTools
using Images
using ImageView

yaml = "/home/alex/awesome/FlowJl/flows/augmenters.yaml";
flow = YAML.load(open(yaml));
result, config = exec_flow(flow);






# # Save config as txt
# open("saved_config.json", "w") do file
#     write(file, JSON2.write(config))
# end
