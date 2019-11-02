using YAML
using FileIO
using Images


function save_img(img, name)
    if ndims(img) == 2
        img = permutedims(Float16.(img./255), (2,1))
    else
        img = permutedims(Float16.(img./255), (3,2,1))
    end

    if ndims(img) == 2 || size(img, 1) == 1
        img = colorview(Gray, img)
    elseif size(img, 1) == 3
        img = colorview(RGB, img)
    elseif size(img, 1) == 4
        img = colorview(RGBA, img)
    end

    Images.save(name, img)
    return
end
