-- vscode-neovim 専用のキーマップ。
-- CLI 版 Neovim のプラグイン (telescope / neo-tree / gitsigns / bufferline / conform) で
-- 定義しているリーダーキーマップを、VSCode のコマンドにブリッジして同じ操作感を再現する。

local ok, vscode = pcall(require, "vscode")
if not ok then
  return
end

local function action(cmd, opts)
  return function()
    vscode.action(cmd, opts)
  end
end

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- ファイル/コード検索 (telescope 相当)
map("n", "<leader>ff", action("workbench.action.quickOpen"),         "ファイル検索")
map("n", "<leader>fr", action("workbench.action.openRecent"),        "最近開いたファイル")
map("n", "<leader>fg", action("workbench.action.findInFiles"),       "コード内を単語検索 (Grep)")
map("n", "<leader>fb", action("workbench.action.showAllEditors"),    "開いているバッファを検索")

-- ファイルツリー (neo-tree 相当)
map("n", "<leader>e", action("workbench.view.explorer"),             "ファイルツリーの表示/非表示")
map("n", "<leader>o", action("workbench.action.focusSideBar"),       "ファイルツリーにフォーカス")

-- Git ハンク (gitsigns 相当)
map("n", "]c", action("workbench.action.editor.nextChange"),         "次のハンクへ")
map("n", "[c", action("workbench.action.editor.previousChange"),     "前のハンクへ")
map({ "n", "v" }, "<leader>hs", action("git.stageSelectedRanges"),   "ハンクをステージ")
map({ "n", "v" }, "<leader>hr", action("git.revertSelectedRanges"),  "ハンクをリセット")
map("n", "<leader>hu", action("git.unstageSelectedRanges"),          "ステージしたハンクを元に戻す")
map("n", "<leader>hb", action("gitlens.toggleLineBlame"),            "Blame (GitLens があれば)")

-- バッファ/タブ操作 (bufferline 相当)
map("n", "<leader>bp", action("workbench.action.pinEditor"),         "バッファをピン留め/解除")
map("n", "<leader>bo", action("workbench.action.closeOtherEditors"), "現在のバッファ以外を削除")
map("n", "<leader>br", action("workbench.action.closeEditorsToTheRight"), "右側のバッファを削除")
map("n", "<leader>bl", action("workbench.action.closeEditorsToTheLeft"),  "左側のバッファを削除")

-- フォーマット (conform 相当 / Format on save は settings.json で別途有効化)
map({ "n", "v" }, "<leader>cf", action("editor.action.formatDocument"), "ドキュメントをフォーマット")
