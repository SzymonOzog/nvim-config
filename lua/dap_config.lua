local dap = require("dap")

dap.adapters.lldb = {
  type = 'executable',
  command = 'I:\\Program Files\\LLVM\\bin\\lldb-vscode.exe', -- adjust as needed, must be absolute path
  name = 'lldb'
}

dap.configurations.zig = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = '${workspaceFolder}/zig-out/bin/main.exe',
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}
