local nvim_lsp = require 'nvim_lsp'
local lsp = vim.lsp
local diagnostic = require 'diagnostic'

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

-- setup
local function setup()
    nvim_lsp.clangd.setup { on_attach = diagnostic.on_attach }
    nvim_lsp.gopls.setup { on_attach = diagnostic.on_attach }
    nvim_lsp.pyls.setup { on_attach = diagnostic.on_attach }
    nvim_lsp.rust_analyzer.setup { on_attach = diagnostic.on_attach }
    nvim_lsp.tsserver.setup { on_attach = diagnostic.on_attach }

    nvim_lsp.sumneko_lua.setup {
        on_attach = diagnostic.on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" }
                },
                runtime = {
                    version = "LuaJIT"
                }
            }
        }
    }

    nvim_lsp.hie.setup {
        on_attach = require'diagnostic'.on_attach,
        cmd = {"haskell-language-server-wrapper", "--lsp"},
        init_options = {
            haskell = {
                hlintOn = true,
                formattingProvider = "ormolu"
            }
        }
    }

    nvim_lsp.texlab.setup {
        on_attach = require'diagnostic'.on_attach,
        -- settings = {
        --     latex = {
        --         build = {
        --             onSave = true
        --         }
        --     }
        -- }
    }
end

return {
    setup = setup,
    formatting_sync = formatting_sync,
}
