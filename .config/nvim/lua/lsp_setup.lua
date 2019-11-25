local lsp_setup = {}

local nvim_lsp = require 'nvim_lsp'
local lsp_callbacks = require 'lsp_callbacks'

function lsp_setup.setup()
    nvim_lsp.clangd.setup { callbacks = lsp_callbacks }
    nvim_lsp.gopls.setup { callbacks = lsp_callbacks }
    nvim_lsp.pyls.setup { callbacks = lsp_callbacks }
    nvim_lsp.rls.setup { callbacks = lsp_callbacks }

    nvim_lsp.hie.setup {
        callbacks = lsp_callbacks,
        settings = {
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

return lsp_setup
