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

vim.keymap.set({ 'n', 'v' }, '<Leader>dS', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.sessions)
end, { desc = '[D]ebug [S]essions' })

vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end, { desc = '[D]ebug [F]rames' })

vim.keymap.set('n', '<Leader>dc', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end, { desc = '[D]ebug s[c]opes' })

vim.keymap.set('n', '<Leader>du', function() require('dapui').toggle() end, { desc = '[D]ebug [U]I' })

local function get_first_terminal()
    local terminal_chans = {}

    for _, chan in pairs(vim.api.nvim_list_chans()) do
        if chan["mode"] == "terminal" and chan["pty"] ~= "" then
            table.insert(terminal_chans, chan)
        end
    end

    if table.getn(terminal_chans) == 0 then
        return nil;
    end

    table.sort(terminal_chans, function(left, right)
        return left["buffer"] < right["buffer"]
    end)

    return terminal_chans[1]
end

local function terminal_send(text)
    local first_terminal_chan = get_first_terminal()["id"]

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

  return scene_name
end

local function get_first_scene_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local end_line = vim.fn.line('$')
    local scene_name = nil

  for i = end_line, 1, -1 do
    local line = lines[i]
    -- Match class definitions that inherit from Scene or its variants
    local match = line:match("^%s*class%s+([%w_]+)%s*%(%s*[%w_]*Scene%s*%)")

    if match and match ~= "Scene" then
      scene_name = match
      break
    end
  end

  return scene_name
end

local function parse_frame_data_and_create_command()
    local term_chan = get_first_terminal()["id"]
    local term_buf = vim.api.nvim_get_chan_info(term_chan).buffer
    -- Get all lines from the terminal buffer
    local lines = vim.api.nvim_buf_get_lines(term_buf, -11, -1, false)
    -- Variables to store parsed values
    local euler_angles = nil
    local center = nil
    local shape = nil
    -- Parse the output
    for i, line in ipairs(lines) do
        -- Look for euler angles output
        local angles_match = line:match("Out%[%d+%]: array%(%[(.-)%]%)$")
        if angles_match and not euler_angles then
            euler_angles = angles_match
        end
        -- Look for center output
        local center_match = line:match("Out%[%d+%]: array%(%[(.-)%]")
        if center_match and line:find("dtype=float32") and not center then
            center = center_match
        end
        -- Look for shape output
        local shape_match = line:match("Out%[%d+%]: %((.-)%)$")
        if shape_match and not shape then
            shape = shape_match
        end
        -- If we've found all values, we can stop
        if euler_angles and center and shape then
            break
        end
    end
    -- Create the animation command
    if euler_angles and center and shape then
        local command = string.format(
            "self.frame.animate.set_euler_angles(%s).set_shape(%s).move_to([%s])",
            euler_angles,
            shape,
            center
        )
        -- Copy to clipboard or insert in buffer
        vim.fn.setreg('+', command)
        print("Animation command copied to clipboard: " .. command)
        return command
    else
        print("Could not parse all required values from terminal output")
        return nil
    end
end

local function run_manim(line, scene)
    local curr_term = get_first_terminal()

    -- close the current terminal if it exists
    if curr_term then
        -- delete the terminal buffer
        vim.api.nvim_buf_delete(curr_term.buffer, { force = true })
    end

    local file = vim.fn.expand('%:p')
    local command = "manimgl " .. "-l " .. file .. " " .. scene .. " -se " .. tostring(line)

    local curr_buf = vim.api.nvim_get_current_buf()
    local curr_win = vim.api.nvim_get_current_win()

    vim.cmd(":wa")
    vim.cmd("botright split | resize 15 | terminal")

    vim.api.nvim_feedkeys('i'..command.."\n", 'n', false)
        vim.schedule(function()
        vim.api.nvim_set_current_win(curr_win)
        vim.api.nvim_set_current_buf(curr_buf)
    end)
end

vim.keymap.set('n', '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = '[C]ode[C]ompanion Chat Toggle' })

vim.api.nvim_create_autocmd("VimLeavePre", {
    desc = "Close CodeCompanion chat buffers before exiting to avoid dead windows on restore",
    callback = function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "codecompanion" then
                vim.api.nvim_buf_delete(buf, { force = true })
            end
        end
    end,
})

vim.keymap.set('n', '<leader>ma', function()
    local line = vim.fn.line('.')
    run_manim(line, get_current_scene_name())
end,
{ desc = "[m][a]nim"})

vim.keymap.set('n', '<leader>me', function()
    local line = vim.fn.line('$')
    run_manim(line, get_first_scene_name())
end,
{ desc = "[m]anim [e]nd"})

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

vim.keymap.set('n', '<Leader>mf',  function ()
    terminal_send("self.frame.get_euler_angles()\n")
    terminal_send("self.frame.get_center()\n")
    terminal_send("self.frame.get_shape()\n")
    vim.cmd.sleep(1)
    parse_frame_data_and_create_command()
end, {desc = "[m]anim [f]rame"})
