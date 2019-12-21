local lsp_callbacks = {}

local util = vim.lsp.util

local my_lsp_utils = require 'lsp_utils'

lsp_callbacks['textDocument/publishDiagnostics'] = function(_, _, result)
    if not result then return end

    local bufnr = vim.uri_to_bufnr(result.uri)

    my_lsp_utils.buf_clear_diagnostics(bufnr)
    my_lsp_utils.buf_diagnostics_save_positions(bufnr, result.diagnostics)
    util.buf_diagnostics_underline(bufnr, result.diagnostics)
    my_lsp_utils.buf_show_marks(bufnr, result.diagnostics)

    if result.diagnostics then
        for _, v in ipairs(result.diagnostics) do
            v.uri = v.uri or result.uri
        end

        util.set_loclist(result.diagnostics)
    end
end

return lsp_callbacks
