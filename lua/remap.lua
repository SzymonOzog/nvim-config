vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set("n", "<leader>E", vim.cmd.Ex, { desc = '[E]xplorer' })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files({hidden=1}) end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').lsp_references, { desc = '[S]earch [R]eferences' })
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndootree' })
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = '[G]it [S]tuff' })
vim.keymap.set('n', '<esc>', vim.cmd.noh)

vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('x', '<leader>p', "\"_dP")

vim.keymap.set('n', '<leader>y', "\"+y")
vim.keymap.set('v', '<leader>y', "\"+y")
vim.keymap.set('n', '<leader>Y', "\"+Y")

vim.keymap.set('n', '<leader>f', function()
    print("formatting")
    vim.lsp.buf.format({ timeout_ms = 25000 })
end)

vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>lp',
    function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end, { desc = '[D]ebug [H]hover' })

vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end, { desc = '[D]ebug [P]review' })

vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end, { desc = '[D]ebug [F]rames' })

vim.keymap.set('n', '<Leader>dS', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end, { desc = '[D]ebug [S]copes' })

vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug [U]I' })

local function get_first_terminal()
    local terminal_chans = {}

    for _, chan in pairs(vim.api.nvim_list_chans()) do
        if chan["mode"] == "terminal" and chan["pty"] ~= "" then
            table.insert(terminal_chans, chan)
        end
    end

    table.sort(terminal_chans, function(left, right)
        return left["buffer"] < right["buffer"]
    end)

    return terminal_chans[1]["id"]
end

local function terminal_send(text)
    local first_terminal_chan = get_first_terminal()

    vim.api.nvim_chan_send(first_terminal_chan, text)
end

local function get_current_scene_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local cursor_line = vim.fn.line('.') - 1
    local scene_name = nil

  for i = cursor_line, 1, -1 do
    local line = lines[i]
    -- Match class definitions that inherit from Scene or its variants
    local match = line:match("^%s*class%s+([%w_]+)%s*%(%s*[%w_]*Scene%s*%)")

    if match and match ~= "Scene" then
      scene_name = match
      break
    end
  end

  return scene_name or error("Scene name not found")
end

vim.keymap.set('n', '<Leader>ma', function()
    local line = vim.fn.line('.')
    local file = vim.fn.expand('%:p')
    local command = "manimgl " .. "-l " .. file .. " " .. get_current_scene_name() .. " -se " .. tostring(line)
    vim.cmd("botright split | terminal ")
    vim.api.nvim_feedkeys('i'..command.."\n", 'n', false)

end,
{ desc = "[m][a]nim"})

-- Map for visual mode
vim.keymap.set('v', '<Leader>ma',  function ()
    vim.cmd('normal! "+y')
    terminal_send("checkpoint_paste()\n")
end, {desc = "[m][a]nim run"})

vim.keymap.set('n', '<Leader>mr',  function ()
    terminal_send("reload()\n")
end, {desc = "[m]anim [r]eload"})

vim.keymap.set('n', '<Leader>mc',  function ()
    terminal_send("clear_checkpoints()\n")
end, {desc = "[m]anim [c]lear"})
