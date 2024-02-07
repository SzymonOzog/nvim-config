local harpoon = require("harpoon")

harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })


vim.keymap.set("n", "<leader>m", function() harpoon:list():append() end, {desc = '[m]ark for harpoon'})
vim.keymap.set("n", "<leader>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, {desc = '[H]arpoon quick menu'})

vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end,{desc = 'harpoon tab [1]'})
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end,{desc = 'harpoon tab [2]'})
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end,{desc = 'harpoon tab [3]'})
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end,{desc = 'harpoon tab [4]'})
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end,{desc = 'harpoon tab [5]'})
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end,{desc = 'harpoon tab [6]'})
vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end,{desc = 'harpoon tab [7]'})
vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end,{desc = 'harpoon tab [8]'})
vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end,{desc = 'harpoon tab [9]'})

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-n>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-m>", function() harpoon:list():next() end)
