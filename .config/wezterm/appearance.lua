-- WezTerm 外観設定
-- フォント、カラースキーム、ウィンドウ、タブ、ペインなどの見た目に関する設定

local wezterm = require("wezterm")
local M = {}

-- 設定をconfigオブジェクトに適用する関数
function M.apply_to_config(config)
  -- ========================================
  -- フォント設定
  -- ========================================

  -- 日本語対応のフォント設定（フォールバック付き）
  -- メインフォントが見つからない文字は、次のフォントで表示される
  config.font = wezterm.font_with_fallback({
    { family = "JetBrains Mono", weight = "Medium" },
    { family = "HackGen Console NF", weight = "Regular" }, -- 日本語フォールバック
  })
  config.font_size = 13.0
  config.line_height = 1.1 -- 行間を少し広げて読みやすく

  -- ========================================
  -- カラースキーム
  -- ========================================

  -- Neovimと統一してGruvboxを使用
  -- 利用可能なスキーム一覧: wezterm ls-fonts --list-colors
  config.color_scheme = "Gruvbox dark, hard (base16)"

  -- ========================================
  -- ウィンドウ設定
  -- ========================================

  -- 背景の透過設定（0.0=完全透明、1.0=不透明）
  config.window_background_opacity = 0.92
  config.macos_window_background_blur = 20 -- macOS専用: 背景をぼかす

  -- ウィンドウ装飾（タイトルバー等）
  -- "FULL": 通常のタイトルバー
  -- "RESIZE": タイトルバーなし、リサイズのみ可能
  -- "NONE": 完全にボーダーレス
  config.window_decorations = "RESIZE"

  -- ウィンドウパディング（内側の余白）
  config.window_padding = {
    left = 8,
    right = 8,
    top = 8,
    bottom = 8,
  }

  -- ========================================
  -- タブバー設定
  -- ========================================

  -- タブが1つだけの場合はタブバーを非表示
  config.hide_tab_bar_if_only_one_tab = true

  -- タブバーのスタイル
  config.use_fancy_tab_bar = false -- シンプルなタブバーを使用（falseで高速）
  config.tab_bar_at_bottom = false -- タブバーを上部に配置
  config.tab_max_width = 32 -- タブの最大幅（文字数）

  -- ========================================
  -- ペイン設定
  -- ========================================

  -- 非アクティブなペインの見た目を変更
  -- アクティブなペインを視覚的に区別しやすくする
  config.inactive_pane_hsb = {
    saturation = 0.8, -- 彩度を80%に（1.0が元の彩度）
    brightness = 0.7, -- 輝度を70%に（1.0が元の輝度）
  }
end

return M
