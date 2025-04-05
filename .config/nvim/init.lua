vim.opt.spell = false
vim.opt.title = true
vim.opt.titlestring = "%f"
vim.opt.list = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.foldenable = false
vim.opt.autochdir = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.breakindent = true
vim.opt.confirm = true
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.signcolumn = "no"
vim.opt.pumheight = 5
vim.opt.scrolloff = 10
vim.opt.cinoptions = { "N-s", "g0", "+0" }
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.wildignore = { "*.so", "*.swp", "*.zip", "*.o", "*.tar*" }
vim.opt.shortmess:append("caI")
vim.opt.clipboard = "unnamedplus"
vim.opt.listchars = [[tab:  ]]
vim.opt.fillchars = [[eob: ]]
vim.opt.winborder = "rounded"

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
vim.opt.inccommand = "nosplit"

vim.g.loaded_python_provider = 0
vim.g.netrw_dirhistmax = 0
vim.g.mapleader = " "

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {
      higroup = "IncSearch",
      timeout = 500,
      on_visual = false,
    }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "cs", "java" },
  callback = function()
    vim.cmd.setlocal([[commentstring=//\ %s]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.cmd.setlocal([[formatoptions-=c formatoptions-=r formatoptions-=o]])
  end,
})

vim.cmd.command([[DeleteTrailingWhitespace :%s/\s\+$//e]])

local map_default_opts = { silent = true }

local function map(mode, lhs, rhs, opts)
  local options = opts or map_default_opts
  vim.keymap.set(mode, lhs, rhs, options)
end

local function buf_map(mode, lhs, rhs)
  map(mode, lhs, rhs, { buffer = true })
end

map({ "n", "x", "o" }, "r", "j")
map({ "n", "x", "o" }, "j", "r")
map({ "n", "x", "o" }, "t", "k")
map({ "n", "x", "o" }, "k", "t")
map("x", "<", "<gv")
map("x", ">", ">gv")
map("n", "<leader>i", ":e ~/.config/nvim/init.lua<CR>")
map("t", "<esc>", [[<C-\><C-n>]])
map("n", "<cr>", [[&buftype ==# 'quickfix' ? "\<cr>" : "o<esc>"]], { expr = true })

vim.diagnostic.config({
  signs = false,
  -- virtual_lines = true,
  virtual_lines = {
    current_line = true,
  },
})

-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local neogit = require("neogit")
      neogit.setup {
        kind = "replace",
        disable_commit_confirmation = true,
        disable_hint = true,
      }
      map("n", "<leader>gs", neogit.open)
    end,
  },
  {
    "max397574/better-escape.nvim",
    opts = {
      mappings = {
        i = {
          h = {
            h = "<Esc>",
          },
        },
      },
    },
  },
  {
    "kylechui/nvim-surround",
    config = true,
  },
  {
    "nvim-focus/focus.nvim",
    opts = {},
  },
  {
    "ggandor/leap.nvim",
    config = function()
      require("leap").add_default_mappings()

      vim.api.nvim_create_autocmd(
        "User",
        {
          callback = function()
            vim.cmd.highlight("Cursor", "blend=100")
            vim.opt.guicursor:append { "a:Cursor/lCursor" }
          end,
          pattern = "LeapEnter",
        }
      )
      vim.api.nvim_create_autocmd(
        "User",
        {
          callback = function()
            vim.cmd.highlight("Cursor", "blend=0")
            vim.opt.guicursor:remove { "a:Cursor/lCursor" }
          end,
          pattern = "LeapLeave",
        }
      )
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        filter = function(c)
          return c.name ~= "ts_ls"
        end,
      },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      git = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      words = {
        enabled = true,
        debounce = 500,
      },
    },
    keys = {
      { "<leader><space>", function()
        Snacks.picker.smart({
          multi = {
            "buffers",
            "recent",
            {
              source = "files",
              cwd = Snacks.git.get_root(),
              hidden = true,
              args = { "--type", "d" },
            } },
        })
      end },
      { "<leader>n", function() Snacks.picker.grep({ cwd = Snacks.git.get_root(), hidden = true }) end },
      { "<leader>h", function() Snacks.picker.help() end },
      { "/",         function() Snacks.picker.lines() end },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local nvim_lsp = require("lspconfig")

      -- TODO LspAttach autocmd
      local function lsp_on_attach(client, bufnr)
        local lsp_format = function()
          require("conform").format {
            bufnr = bufnr,
          }
        end

        buf_map("n", "gd", Snacks.picker.lsp_definitions)
        buf_map("n", "<leader>f", lsp_format)
        buf_map("n", "<leader>r", vim.lsp.buf.rename)
        buf_map("n", "<leader>a", vim.lsp.buf.code_action)
        buf_map("n", "<leader>d", vim.diagnostic.open_float)
        buf_map("n", "<leader>en", function() vim.diagnostic.jump { count = 1, float = false } end)
        buf_map("n", "<leader>ep", function() vim.diagnostic.jump { count = -1, float = false } end)
        buf_map("n", "<leader>el", Snacks.picker.diagnostics)
        buf_map("n", "<leader>s", Snacks.picker.lsp_symbols)
        buf_map("n", "<leader>w", Snacks.picker.lsp_workspace_symbols)
        buf_map("n", "<leader>c", Snacks.picker.lsp_references)
        buf_map("n", "<leader>y", Snacks.picker.lsp_type_definitions)

        client.server_capabilities.semanticTokensProvider = nil
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      nvim_lsp.clangd.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.gopls.setup {
        settings = {
          gopls = {
            analyses = {
              unreachable = true,
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.rust_analyzer.setup {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
          },
        },
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.texlab.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.tinymist.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
        settings = {
          formatterMode = "typstyle",
        },
      }

      nvim_lsp.ts_ls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.hls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.lua_ls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.bashls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.html.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.cssls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.tailwindcss.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.jsonls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      -- nvim_lsp.yamlls.setup {
      --   on_attach = lsp_on_attach,
      --   capabilities = capabilities,
      -- }

      nvim_lsp.docker_compose_language_service.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.dockerls.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.pyright.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.ruff.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }

      nvim_lsp.biome.setup {
        on_attach = lsp_on_attach,
        capabilities = capabilities,
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = "all",
      highlight = {
        enable = true,
        disable = { "markdown" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    opts = {
      keymap = { preset = "enter" },
      cmdline = {
        keymap = {
          preset = "super-tab",
        },
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
  },
  {
    "j-hui/fidget.nvim",
    opts = {},
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
})

vim.api.nvim_set_hl(0, "Search", {})
vim.api.nvim_set_hl(0, "QuickFixLine", {})

-- vim.api.nvim_set_hl(0, "TrailingWhitespace", { ctermbg = "red", bg = "red" })
-- vim.cmd.match([[TrailingWhitespace /\s\+\%#\@<!$/]])
