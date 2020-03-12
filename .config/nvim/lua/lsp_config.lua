local nvim_lsp = require 'nvim_lsp'
local lsp = vim.lsp
local api = vim.api

-- utils
local all_buffer_diagnostics = {}
local diagnostic_ns = api.nvim_create_namespace("vim_lsp_diagnostics")

local function formatting_sync()
    local params = {
        textDocument = { uri = vim.uri_from_bufnr(0) },
        options = {
            tabSize = vim.bo.tabstop;
            insertSpaces = vim.bo.expandtab;
        }
    }

    local res = lsp.buf_request_sync(0, 'textDocument/formatting', params)

    for _, r in ipairs(res) do
        lsp.util.apply_text_edits(r.result)
    end
end

local function get_highest_severity_for_line(line_diags)
    local highest = line_diags[1].severity

    for i = 2, #line_diags do
        local current = line_diags[i].severity
        if current > highest then
            highest = current
        end
    end

    return highest
end

local function buf_diagnostics_save_positions(bufnr, diagnostics)
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

local function get_all_buffer_diagnostics()
    return all_buffer_diagnostics
end

local function buf_clear_diagnostics(bufnr)
    api.nvim_buf_clear_namespace(bufnr, diagnostic_ns, 0, -1)
end

local function buf_show_marks(bufnr, _)
    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then return end

    for line, line_diags in pairs(buffer_line_diagnostics) do
        local highest_severity = get_highest_severity_for_line(line_diags)
        local virt_text = {{"■", lsp.util.get_severity_highlight_name(highest_severity)}}

        api.nvim_buf_set_virtual_text(bufnr, diagnostic_ns, line, virt_text, {})
    end
end

local function show_line_diagnostics()
    local bufnr = api.nvim_get_current_buf()
    local line = api.nvim_win_get_cursor(0)[1] - 1

    -- local marks = api.nvim_buf_get_extmarks(bufnr, diagnostic_ns, {line, 0}, {line, -1}, {})
    -- if #marks == 0 then
    --   return
    -- end

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
        local hiname = lsp.util.get_severity_highlight_name(diagnostic.severity)
        local message_lines = vim.split(diagnostic.message, '\n', true)
        table.insert(lines, prefix..message_lines[1])
        table.insert(highlights, {#prefix + 1, hiname})

        for j = 2, #message_lines do
            table.insert(lines, message_lines[j])
            table.insert(highlights, {0, hiname})
        end
    end

    local popup_bufnr, winnr = lsp.util.open_floating_preview(lines,
        'plaintext')

    for i, hi in ipairs(highlights) do
        local prefixlen, hiname = unpack(hi)
        -- Start highlight after the prefix
        api.nvim_buf_add_highlight(popup_bufnr, -1, hiname, i-1, prefixlen, -1)
    end

    return popup_bufnr, winnr
end

-- callbacks
local lsp_callbacks = {}

lsp_callbacks['textDocument/publishDiagnostics'] = function(_, _, result)
    if not result then return end

    local bufnr = vim.uri_to_bufnr(result.uri)

    buf_clear_diagnostics(bufnr)
    buf_diagnostics_save_positions(bufnr, result.diagnostics)
    buf_show_marks(bufnr, result.diagnostics)
    lsp.util.buf_diagnostics_underline(bufnr, result.diagnostics)

    if result.diagnostics then
        for _, v in ipairs(result.diagnostics) do
            v.uri = v.uri or result.uri
        end

        lsp.util.set_loclist(result.diagnostics)
    end
end

-- setup
local function setup()
    -- nvim_lsp.clangd.setup { callbacks = lsp_callbacks }
    nvim_lsp.clangd.setup {}
    nvim_lsp.gopls.setup { callbacks = lsp_callbacks }
    nvim_lsp.pyls.setup { callbacks = lsp_callbacks }
    nvim_lsp.rust_analyzer.setup { callbacks = lsp_callbacks }
    nvim_lsp.tsserver.setup { callbacks = lsp_callbacks }

    nvim_lsp.sumneko_lua.setup {
        callbacks = lsp_callbacks,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" }
                }
            }
        }
    }

    nvim_lsp.hie.setup {
        callbacks = lsp_callbacks,
        cmd = {"hie-wrapper", "--lsp"},
        init_options = {
            languageServerHaskell = {
                hlintOn = true
            }
        }
    }

    nvim_lsp.texlab.setup {
        callbacks = lsp_callbacks,
        settings = {
            latex = {
                build = {
                    onSave = true
                }
            }
        }
    }
end

return {
    setup = setup,
    lsp_callbacks = lsp_callbacks,
    show_line_diagnostics = show_line_diagnostics,
    formatting_sync = formatting_sync,
    get_highest_severity_for_line = get_highest_severity_for_line,
    get_all_buffer_diagnostics = get_all_buffer_diagnostics,
    buf_diagnostics_save_positions = buf_diagnostics_save_positions,
    buf_clear_diagnostics = buf_clear_diagnostics,
    buf_show_marks = buf_show_marks
}
