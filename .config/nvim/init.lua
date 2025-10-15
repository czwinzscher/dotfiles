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

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
  },
})

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
map("n", "<leader>o", ":e .<CR>")

vim.diagnostic.config({
  signs = false,
  -- virtual_text = true,
  -- virtual_lines = true,
  -- virtual_lines = {
  --   current_line = true,
  -- },
})


local format_filter = function(c)
  return c.name ~= "ts_ls" and c.name ~= "jsonls"
end

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
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-x>",
          accept_line = "<M-v>",
        },
      },
      filetypes = {
        -- toml = true,
      },
    },
  },
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
        filter = format_filter,
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
      { "<leader>l", function() Snacks.picker.resume() end },
      { "/",         function() Snacks.picker.lines() end },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          local lsp_format = function()
            require("conform").format {
              filter = format_filter,
            }
          end

          buf_map("n", "gd", Snacks.picker.lsp_definitions)
          buf_map("n", "<leader>f", lsp_format)
          buf_map("n", "<leader>r", vim.lsp.buf.rename)
          buf_map("n", "<leader>a", vim.lsp.buf.code_action)
          buf_map("n", "<leader>d", vim.diagnostic.open_float)
          buf_map("n", "<leader>en", function()
            vim.diagnostic.jump { count = 1, float = false }
          end)
          buf_map("n", "<leader>ep", function()
            vim.diagnostic.jump { count = -1, float = false }
          end)
          buf_map("n", "<leader>el", Snacks.picker.diagnostics)
          buf_map("n", "<leader>s", Snacks.picker.lsp_symbols)
          buf_map("n", "<leader>w", Snacks.picker.lsp_workspace_symbols)
          buf_map("n", "<leader>c", Snacks.picker.lsp_references)
          buf_map("n", "<leader>y", Snacks.picker.lsp_type_definitions)

          client.server_capabilities.semanticTokensProvider = nil
        end,
      })

      vim.lsp.config("clangd", {})
      vim.lsp.enable("clangd")

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = {
              unreachable = true,
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
      })
      vim.lsp.enable("gopls")

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
            },
            cargo = {
              targetDir = true,
            },
            imports = {
              granularity = {
                group = "item",
                -- enforce = true,
              },
            },
          },
        },
      })
      vim.lsp.enable("rust_analyzer")

      -- vim.lsp.config("texlab", {
      -- })
      -- vim.lsp.enable("texlab")

      vim.lsp.config("tinymist", {
        settings = {
          formatterMode = "typstyle",
        },
      })
      vim.lsp.enable("tinymist")

      vim.lsp.config("ts_ls", {})
      vim.lsp.enable("ts_ls")

      vim.lsp.config("hls", {})
      vim.lsp.enable("hls")

      vim.lsp.config("lua_ls", {})
      vim.lsp.enable("lua_ls")

      vim.lsp.config("bashls", {})
      vim.lsp.enable("bashls")

      vim.lsp.config("html", {})
      vim.lsp.enable("html")

      vim.lsp.config("cssls", {})
      vim.lsp.enable("cssls")

      vim.lsp.config("tailwindcss", {})
      vim.lsp.enable("tailwindcss")

      vim.lsp.config("jsonls", {})
      vim.lsp.enable("jsonls")

      -- vim.lsp.config("yamlls", {
      --   on_attach = lsp_on_attach,
      -- })
      -- vim.lsp.enable("yamlls")

      vim.lsp.config("docker_compose_language_service", {})
      vim.lsp.enable("docker_compose_language_service")
      vim.lsp.config("dockerls", {})
      vim.lsp.enable("dockerls")

      vim.lsp.config("pyright", {})
      vim.lsp.enable("pyright")

      vim.lsp.config("ruff", {})
      vim.lsp.enable("ruff")

      vim.lsp.config("biome", {})
      vim.lsp.enable("biome")
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
