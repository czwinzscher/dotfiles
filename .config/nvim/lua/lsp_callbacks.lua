local util = require 'vim.lsp.util'
local api = vim.api

local lsp_callbacks = {}

local function uri_to_bufnr(uri)
    return vim.fn.bufadd((vim.uri_to_fname(uri)))
end

lsp_callbacks['textDocument/publishDiagnostics'] = function(_, _, result)
    if not result then return end

    local uri = result.uri
    local bufnr = uri_to_bufnr(uri)
    if not bufnr then
        api.nvim_err_writeln(string.format(
            "LSP.publishDiagnostics: Couldn't find buffer for %s", uri))
        return
    end

    util.buf_clear_diagnostics(bufnr)
    util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
    util.buf_diagnostics_underline(bufnr, result.diagnostics)
    util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
    util.buf_loclist(bufnr, result.diagnostics)
end

return lsp_callbacks
