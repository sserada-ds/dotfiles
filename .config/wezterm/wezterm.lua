-- WezTerm Configuration
-- author: Sera (https://github.com/sserada)
-- WezTermはRustで書かれたGPUアクセラレーション対応のターミナルエミュレータ
-- Luaで高度にカスタマイズ可能で、tmuxのようなマルチプレクサ機能も内蔵

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ========================================
-- フォント設定
-- ========================================

-- 日本語対応のフォント設定（フォールバック付き）
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
config.color_scheme = "Gruvbox dark, hard (base16)"

-- ========================================
-- ウィンドウ設定
-- ========================================

-- 背景の透過設定
config.window_background_opacity = 0.92
config.macos_window_background_blur = 20 -- macOS専用: 背景をぼかす

-- ウィンドウ装飾（タイトルバー等）
config.window_decorations = "RESIZE" -- タイトルバーを非表示にしてリサイズのみ可能

-- ウィンドウパディング
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
config.use_fancy_tab_bar = false -- シンプルなタブバーを使用
config.tab_bar_at_bottom = false -- タブバーを上部に配置
config.tab_max_width = 32

-- ========================================
-- ペイン設定
-- ========================================

-- 非アクティブなペインの見た目を変更（彩度と輝度を下げる）
config.inactive_pane_hsb = {
  saturation = 0.8, -- 彩度を80%に
  brightness = 0.7, -- 輝度を70%に
}

-- ========================================
-- 入力設定
-- ========================================

-- IME（日本語入力）を有効化
config.use_ime = true

-- ========================================
-- スクロールバック設定
-- ========================================

-- スクロールバックの行数
config.scrollback_lines = 10000

-- ========================================
-- キーバインド設定
-- ========================================

config.keys = {
  -- ペイン分割（tmux風のキーバインド）
  {
    key = "d",
    mods = "CMD",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "D",
    mods = "CMD|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- ペイン間の移動（tmux風: Cmd+hjkl）
  {
    key = "h",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "CMD",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },

  -- ペインを閉じる
  {
    key = "w",
    mods = "CMD",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },

  -- ペインのズーム切り替え（全画面表示）
  {
    key = "z",
    mods = "CMD",
    action = wezterm.action.TogglePaneZoomState,
  },

  -- タブ操作
  {
    key = "t",
    mods = "CMD",
    action = wezterm.action.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "[",
    mods = "CMD",
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = "]",
    mods = "CMD",
    action = wezterm.action.ActivateTabRelative(1),
  },

  -- 設定ファイルをリロード
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = wezterm.action.ReloadConfiguration,
  },
}

-- ========================================
-- マウス設定
-- ========================================

-- URLをクリックしたときにブラウザで開く
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

-- ========================================
-- パフォーマンス設定
-- ========================================

-- GPUを使用してレンダリング（デフォルトで有効）
config.front_end = "WebGpu" -- WebGPUバックエンドを使用（高速）
config.max_fps = 120 -- 最大FPS（滑らかな表示）

-- ========================================
-- その他の設定
-- ========================================

-- 自動更新チェックを有効化
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400 -- 1日に1回

-- ベルを無効化（音を鳴らさない）
config.audible_bell = "Disabled"

-- ウィンドウを閉じる際の確認
config.window_close_confirmation = "NeverPrompt" -- プロセスが実行中でも確認しない

-- 起動時のシェル（デフォルトはシステムのログインシェル）
-- config.default_prog = { "/bin/zsh", "-l" } -- 必要に応じてコメント解除

return config
