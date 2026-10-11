-- Alma Sakura カラースキーム
-- VSCode の "Alma Dimmed Sakura" テーマを Neovim に移植したローカルカラースキーム。
-- 実体は `colors/alma-sakura.lua` にあり、ここでは lazy.nvim にローカルプラグインとして登録するだけ。
return {
  dir = vim.fn.stdpath("config"), -- ローカルプラグイン (Neovim 設定ディレクトリそのもの)
  name = "alma-sakura",
  priority = 1000,                -- 他プラグインより先に読み込む
  lazy = false,                   -- 起動時に即適用
  config = function()
    vim.cmd.colorscheme("alma-sakura")
  end,
}
