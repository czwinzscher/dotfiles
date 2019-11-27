local lsp_setup = {}

local nvim_lsp = require 'nvim_lsp'
local lsp_callbacks = require 'lsp_callbacks'

function lsp_setup.setup()
    nvim_lsp.clangd.setup { callbacks = lsp_callbacks }
    nvim_lsp.gopls.setup {}
    nvim_lsp.pyls.setup {}
    nvim_lsp.rust_analyzer.setup {}
    nvim_lsp.texlab.setup {}

    nvim_lsp.hie.setup {
        settings = {
            languageServerHaskell = {
                hlintOn = true
            }
        }
    }
end

return lsp_setup
