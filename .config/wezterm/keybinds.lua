-- WezTerm キーバインド設定
-- キーボードショートカットとマウス操作の設定

local wezterm = require("wezterm")
local act = wezterm.action -- アクションのショートハンド
local M = {}

-- 設定をconfigオブジェクトに適用する関数
function M.apply_to_config(config)
  -- ========================================
  -- キーバインド設定
  -- ========================================

  config.keys = {
    -- ----------------------------------------
    -- ペイン操作
    -- ----------------------------------------

    -- ペイン分割（tmux風）
    {
      key = "d",
      mods = "CMD",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "D",
      mods = "CMD|SHIFT",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },

    -- ペイン間の移動（Vim風: Cmd+hjkl）
    {
      key = "h",
      mods = "CMD",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "j",
      mods = "CMD",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "k",
      mods = "CMD",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      mods = "CMD",
      action = act.ActivatePaneDirection("Right"),
    },

    -- ペインを閉じる
    {
      key = "w",
      mods = "CMD",
      action = act.CloseCurrentPane({ confirm = true }),
    },

    -- ペインのズーム切り替え（全画面表示）
    {
      key = "z",
      mods = "CMD",
      action = act.TogglePaneZoomState,
    },

    -- ペインサイズ調整
    {
      key = "H",
      mods = "CMD|SHIFT",
      action = act.AdjustPaneSize({ "Left", 5 }),
    },
    {
      key = "J",
      mods = "CMD|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Down", 5 }),
    },
    {
      key = "K",
      mods = "CMD|SHIFT|ALT",
      action = act.AdjustPaneSize({ "Up", 5 }),
    },
    {
      key = "L",
      mods = "CMD|SHIFT",
      action = act.AdjustPaneSize({ "Right", 5 }),
    },

    -- ----------------------------------------
    -- タブ操作
    -- ----------------------------------------

    -- 新しいタブを開く
    {
      key = "t",
      mods = "CMD",
      action = act.SpawnTab("CurrentPaneDomain"),
    },

    -- タブ間の移動
    {
      key = "[",
      mods = "CMD",
      action = act.ActivateTabRelative(-1),
    },
    {
      key = "]",
      mods = "CMD",
      action = act.ActivateTabRelative(1),
    },

    -- タブを番号で移動（Cmd+1~9）
    { key = "1", mods = "CMD", action = act.ActivateTab(0) },
    { key = "2", mods = "CMD", action = act.ActivateTab(1) },
    { key = "3", mods = "CMD", action = act.ActivateTab(2) },
    { key = "4", mods = "CMD", action = act.ActivateTab(3) },
    { key = "5", mods = "CMD", action = act.ActivateTab(4) },
    { key = "6", mods = "CMD", action = act.ActivateTab(5) },
    { key = "7", mods = "CMD", action = act.ActivateTab(6) },
    { key = "8", mods = "CMD", action = act.ActivateTab(7) },
    { key = "9", mods = "CMD", action = act.ActivateTab(-1) }, -- 最後のタブ

    -- ----------------------------------------
    -- その他
    -- ----------------------------------------

    -- 設定ファイルをリロード
    {
      key = "r",
      mods = "CMD|SHIFT",
      action = act.ReloadConfiguration,
    },

    -- コピーモード（Vimライクな選択）
    {
      key = "x",
      mods = "CMD|SHIFT",
      action = act.ActivateCopyMode,
    },

    -- コマンドパレットを開く
    {
      key = "p",
      mods = "CMD|SHIFT",
      action = act.ActivateCommandPalette,
    },

    -- デバッグ用オーバーレイを表示
    {
      key = "d",
      mods = "CMD|SHIFT",
      action = act.ShowDebugOverlay,
    },
  }

  -- ========================================
  -- マウス設定
  -- ========================================

  config.mouse_bindings = {
    -- Cmd+クリックでURLをブラウザで開く
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CMD",
      action = act.OpenLinkAtMouseCursor,
    },
  }
end

return M
