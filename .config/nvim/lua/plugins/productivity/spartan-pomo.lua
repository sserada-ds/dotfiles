-- spartan-pomo.nvim
-- スパルタ式ポモドーロタイマー
-- 休憩時間中は強制的に画面がブロックされ、作業を続けられなくなる
-- https://github.com/sserada/spartan-pomo.nvim

return {
  -- ローカル開発用: dirでローカルパスを指定
  dir = vim.fn.expand("~/workspace/spartan-pomo.nvim"),
  name = "spartan-pomo.nvim",
  cmd = { "SpartanStart", "SpartanStop", "SpartanStatus" },
  keys = {
    { "<Leader>ps", "<cmd>SpartanStart<cr>", desc = "Pomodoro Start" },
    { "<Leader>px", "<cmd>SpartanStop<cr>", desc = "Pomodoro Stop" },
    { "<Leader>pp", "<cmd>SpartanStatus<cr>", desc = "Pomodoro Status" },
  },
  opts = {
    -- 作業時間（分）※テスト時は短く設定
    work_time = 15, -- テスト用: 6秒（本番は25に戻す）
    -- 休憩時間（分）
    break_time = 3, -- テスト用: 6秒（本番は5に戻す）
    -- 緊急脱出キー（休憩中にどうしても作業が必要な場合）
    emergency_key = "<Leader><Leader>q",
  },
  config = function(_, opts)
    require("spartan-pomo").setup(opts)
  end,
}
