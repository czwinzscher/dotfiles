local util = vim.lsp.util
local api = vim.api

local lsp_callbacks = {}

lsp_callbacks['textDocument/publishDiagnostics'] = function(_, _, result)
    if not result then return end

    local bufnr = vim.uri_to_bufnr(result.uri)

    if not bufnr then
        err_message("LSP.publishDiagnostics: Couldn't find buffer for ", result.uri)
        return
    end

    util.buf_clear_diagnostics(bufnr)
    util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
    util.buf_diagnostics_underline(bufnr, result.diagnostics)
    util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
    -- util.set_loclist(result.diagnostics)
end

return lsp_callbacks
