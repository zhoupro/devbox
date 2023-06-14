local HOME = os.getenv "HOME"
local DEBUGGER_LOCATION = HOME .. "/.local/share/nvim"


-- Debugging
local bundles = {
    vim.fn.glob(
      DEBUGGER_LOCATION .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
    ),
  }
vim.list_extend(bundles, vim.split(vim.fn.glob(DEBUGGER_LOCATION .. "/vscode-java-test/server/*.jar"), "\n"))

local config = {
    cmd = {DEBUGGER_LOCATION .. '/mason/bin/jdtls'},
    root_dir =vim.fs.dirname(vim.fs.find({'.git','mvnw','gradlew'},{upward=true})[1]),
    init_options = {
        bundles = bundles
    },
}

config.on_attach = function(client,bufnr)
    require("jdtls").setup_dap {hotcodereplace = "auto"}
    require("jdtls").setup.add_commands()
    require("jdtls.dap").setup_dap_main_class_configs()
end

require("jdtls").start_or_attach(config)