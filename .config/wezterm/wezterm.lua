-- WezTerm Configuration
-- author: Sera (https://github.com/sserada)
--
-- WezTermはRustで書かれたGPUアクセラレーション対応のターミナルエミュレータ
-- Luaで高度にカスタマイズ可能で、tmuxのようなマルチプレクサ機能も内蔵
--
-- 設定ファイル構造:
--   wezterm.lua    - メインエントリーポイント（このファイル）
--   appearance.lua - 外観設定（フォント、カラー、ウィンドウ）
--   keybinds.lua   - キーバインド設定

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ========================================
-- 起動時のウィンドウサイズ
-- ========================================

-- 大きめのウィンドウサイズを指定（列数と行数）
-- フォントサイズ13で概算: 1920x1080画面で約145列x50行程度
config.initial_cols = 220
config.initial_rows = 50

-- ========================================
-- モジュールの読み込みと適用
-- ========================================

-- 外観設定を適用
require("appearance").apply_to_config(config)

-- キーバインド設定を適用
require("keybinds").apply_to_config(config)

-- ========================================
-- 入力設定
-- ========================================

-- IME（日本語入力）を有効化
config.use_ime = true

-- ========================================
-- スクロールバック設定
-- ========================================

-- スクロールバックの行数（履歴の保持量）
config.scrollback_lines = 10000

-- ========================================
-- パフォーマンス設定
-- ========================================

-- GPUを使用してレンダリング
-- "WebGpu": 最新のWebGPUバックエンド（高速）
-- "OpenGL": 互換性重視のOpenGLバックエンド
-- "Software": ソフトウェアレンダリング（GPUなし）
config.front_end = "WebGpu"
config.max_fps = 120 -- 最大FPS（滑らかな表示）

-- ========================================
-- その他の設定
-- ========================================

-- 自動更新チェック
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400 -- 1日に1回

-- ベルを無効化（音を鳴らさない）
config.audible_bell = "Disabled"

-- ウィンドウを閉じる際の確認
-- "AlwaysPrompt": 常に確認
-- "NeverPrompt": 確認しない
config.window_close_confirmation = "NeverPrompt"

-- 起動時のシェル（コメント解除で変更可能）
-- config.default_prog = { "/bin/zsh", "-l" }

return config
