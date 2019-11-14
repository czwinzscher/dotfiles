local lsp_setup = {}

local nvim_lsp = require 'nvim_lsp'
local lsp_callbacks = require 'lsp_callbacks'

function lsp_setup.setup()
    nvim_lsp.clangd.setup { callbacks = lsp_callbacks; }
    nvim_lsp.gopls.setup { callbacks = lsp_callbacks; }
    nvim_lsp.pyls.setup { callbacks = lsp_callbacks; }
    nvim_lsp.texlab.setup { callbacks = lsp_callbacks; }

    vim.lsp.add_filetype_config {
        name = "hie";
        filetype = {"haskell"};
        cmd = "hie-wrapper -l /tmp/hie.log";
        callbacks = lsp_callbacks;
    }

    vim.lsp.add_filetype_config {
        name = "rls";
        filetype = {"rust"};
        cmd = "rls";
        callbacks = lsp_callbacks;
    }
end

return lsp_setup
