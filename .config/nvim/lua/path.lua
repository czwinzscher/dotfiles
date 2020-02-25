local uv = vim.loop

local M = {}

function M.exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
end

function M.is_dir(filename)
    return M.exists(filename) == 'directory'
end

function M.is_file(filename)
    return M.exists(filename) == 'file'
end

local path_sep = "/"

local is_fs_root = function(path)
    return path == "/"
end

local dirname
do
    local strip_dir_pat = path_sep.."([^"..path_sep.."]+)$"
    local strip_sep_pat = path_sep.."$"

    dirname = function(path)
        if not path then return end

        local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
        if #result == 0 then
            return "/"
        end

        return result
    end
end

function M.join(...)
    local result = table.concat(
        vim.tbl_flatten {...}, path_sep):gsub(path_sep.."+", path_sep)

    return result
end

-- Traverse the path calling cb along the way.
function M.traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path

    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
        dir = dirname(dir)

        if not dir then return end

        -- If we can't ascend further, then stop looking.
        if cb(dir, path) then
            return dir, path
        end

        if is_fs_root(dir) then
            break
        end
    end
end

-- Iterate the path until we find the rootdir.
function M.iterate_parents(path)
    path = uv.fs_realpath(path)

    local function it(_, v)
        if not v then return end

        if is_fs_root(v) then return end

        return dirname(v), path
    end

    return it, path, path
end

return M
