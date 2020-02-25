local path_utils = require 'path'

local M = {}

local data_dir = vim.api.nvim_call_function('stdpath', {'data'})
local data_file = path_utils.join(data_dir, 'projects.txt')
local root_markers = {'.git/'}

function M.get_project_file()
    return data_file
end

function M.get_project_list()
    local projects_file = io.open(data_file, 'r')

    if not projects_file then return {} end

    local list = {}
    for line in projects_file:lines() do
        table.insert(list, line)
    end

    return list
end

function M.get_root(path)
    local function is_match(path)
        for _, pattern in ipairs(root_markers) do
            if path_utils.exists(path_utils.join(path, pattern)) then
                return true
            end
        end
    end

    for dir in path_utils.iterate_parents(path) do
        if is_match(dir) then
            return dir
        end
    end
end

local function project_exists(path)
    local projects = M.get_project_list()

    for _, val in ipairs(projects) do
        if path == val then
            return true
        end
    end

    return false
end

function M.add_project(path)
    if not path then return end

    if project_exists(path) then return end

    local projects_file = io.open(data_file, 'a')
    projects_file:write(path, '\n')
    projects_file:close()
end

-- TODO
-- function M.remove_project(path)
-- end

function M.check_path()
    local uri = vim.uri_from_bufnr(0)
    local path = vim.uri_to_fname(uri)

    local root = M.get_root(path)
    if root then M.add_project(root) end
end

function M.setup(patterns)
    root_markers = patterns or root_markers

    vim.api.nvim_command('augroup projects')
    vim.api.nvim_command('autocmd!')
    vim.api.nvim_command('autocmd BufAdd * lua require("projects").check_path()')
    vim.api.nvim_command('augroup END')
end

return M
