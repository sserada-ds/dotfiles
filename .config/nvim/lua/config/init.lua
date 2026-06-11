require("config.options")   -- オプション設定の読み込み（leaderキー設定を含むため最初に読み込む）
require("config.keymaps")   -- キーマップの読み込み

-- vscode-neovim から起動された場合は autocmds とプラグイン群をスキップする。
-- これらは VSCode 側の機能と衝突する、または未ロードのプラグインに依存してエラーになるため。
if vim.g.vscode then
  require("config.vscode-keymaps")  -- VSCode コマンドへのブリッジキーマップ
else
  require("config.autocmds")  -- 自動コマンドの読み込み
  require("config.lazy")      -- プラグインマネージャー(lazy.nvim)の読み込み
end
