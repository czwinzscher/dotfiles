local M = {}

local api = vim.api
local lsp = vim.lsp
local util = lsp.util

local all_buffer_diagnostics = {}
local diagnostic_ns = api.nvim_create_namespace("vim_lsp_diagnostics")

function M.formatting_sync()
    local options = vim.tbl_extend('keep', {}, {
            tabSize = vim.bo.tabstop;
            insertSpaces = vim.bo.expandtab;
        })

    local params = {
        textDocument = { uri = vim.uri_from_bufnr(0) },
        options = options
    }

    return lsp.buf_request_sync(0, 'textDocument/formatting', params)
end

function M.buf_diagnostics_save_positions(bufnr, diagnostics)
    vim.validate {
        bufnr = {bufnr, 'n', true};
        diagnostics = {diagnostics, 't', true};
    }

    if not diagnostics then return end

    if not all_buffer_diagnostics[bufnr] then
        -- Clean up our data when the buffer unloads.
        api.nvim_buf_attach(bufnr, false, {
                on_detach = function(b)
                    all_buffer_diagnostics[b] = nil
                end
            })
    end

    all_buffer_diagnostics[bufnr] = {}
    local buffer_diagnostics = all_buffer_diagnostics[bufnr]

    for _, diagnostic in ipairs(diagnostics) do
        local start = diagnostic.range.start
        -- local mark_id = api.nvim_buf_set_extmark(bufnr, diagnostic_ns, 0, start.line, 0, {})
        -- buffer_diagnostics[mark_id] = diagnostic
        local line_diagnostics = buffer_diagnostics[start.line]

        if not line_diagnostics then
            line_diagnostics = {}
            buffer_diagnostics[start.line] = line_diagnostics
        end

        table.insert(line_diagnostics, diagnostic)
    end
end

function M.get_all_buffer_diagnostics()
    return all_buffer_diagnostics
end

function M.buf_clear_diagnostics(bufnr)
    vim.validate { bufnr = {bufnr, 'n', true} }

    api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
end

function M.show_marks(bufnr, diagnostics)
    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]

    if not buffer_line_diagnostics then return end

    for line, line_diags in pairs(buffer_line_diagnostics) do
        local virt_texts = {}

        for i = 1, #line_diags do
            table.insert(virt_texts,
                {"■", util.get_severity_highlight_name(line_diags[i].severity)})
        end

        api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_texts, {})
    end
end

function M.show_line_diagnostics()
    local bufnr = api.nvim_get_current_buf()
    local line = api.nvim_win_get_cursor(0)[1] - 1
    -- local marks = api.nvim_buf_get_extmarks(bufnr, diagnostic_ns, {line, 0}, {line, -1}, {})
    -- if #marks == 0 then
    --   return
    -- end
    -- local buffer_diagnostics = all_buffer_diagnostics[bufnr]
    local lines = {"Diagnostics:"}
    local highlights = {{0, "Bold"}}

    local buffer_diagnostics = all_buffer_diagnostics[bufnr]

    if not buffer_diagnostics then return end

    local line_diagnostics = buffer_diagnostics[line]

    if not line_diagnostics then return end

    for i, diagnostic in ipairs(line_diagnostics) do
        -- for i, mark in ipairs(marks) do
        --   local mark_id = mark[1]
        --   local diagnostic = buffer_diagnostics[mark_id]

        local prefix = string.format("%d. ", i)
        local hiname = util.get_severity_highlight_name(diagnostic.severity)
        local message_lines = vim.split(diagnostic.message, '\n', true)
        table.insert(lines, prefix..message_lines[1])
        table.insert(highlights, {#prefix + 1, hiname})

        for j = 2, #message_lines do
            table.insert(lines, message_lines[j])
            table.insert(highlights, {0, hiname})
        end
    end

    local popup_bufnr, winnr = util.open_floating_preview(lines, 'plaintext')

    for i, hi in ipairs(highlights) do
        local prefixlen, hiname = unpack(hi)
        -- Start highlight after the prefix
        api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i-1, prefixlen, -1)
    end

    return popup_bufnr, winnr
end

return M
