local M = {}

local nvim_lsp = require 'nvim_lsp'
local lsp_callbacks = require 'lsp_callbacks'

function M.setup()
    nvim_lsp.clangd.setup { callbacks = lsp_callbacks }
    nvim_lsp.gopls.setup { callbacks = lsp_callbacks }
    nvim_lsp.pyls.setup { callbacks = lsp_callbacks }
    nvim_lsp.rust_analyzer.setup { callbacks = lsp_callbacks }
    nvim_lsp.texlab.setup { callbacks = lsp_callbacks }

    nvim_lsp.hie.setup {
        callbacks = lsp_callbacks,
        settings = {
            languageServerHaskell = {
                hlintOn = true
            }
        }
    }
end

return M
