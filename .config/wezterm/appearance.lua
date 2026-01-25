-- WezTerm 外観設定
-- フォント、カラースキーム、ウィンドウ、タブ、ペインなどの見た目に関する設定

local wezterm = require("wezterm")
local M = {}

-- assetsディレクトリから画像をランダムに選択する関数
local function select_random_background()
  local assets_dir = wezterm.home_dir .. "/.config/wezterm/assets"

  -- サポートする画像形式
  local image_extensions = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp" }

  -- assetsディレクトリが存在しない場合はnilを返す
  local success, files = pcall(function()
    return wezterm.read_dir(assets_dir)
  end)

  if not success then
    wezterm.log_info("Assets directory not found: " .. assets_dir)
    return nil
  end

  -- 画像ファイルのみをフィルタ
  local images = {}
  for _, file in ipairs(files) do
    local lower_file = file:lower()
    for _, ext in ipairs(image_extensions) do
      if lower_file:match(ext .. "$") then
        table.insert(images, assets_dir .. "/" .. file)
        break
      end
    end
  end

  -- 画像が見つからない場合
  if #images == 0 then
    wezterm.log_info("No images found in assets directory")
    return nil
  end

  -- ランダムに1つ選択
  math.randomseed(os.time())
  local random_index = math.random(1, #images)
  local selected = images[random_index]

  wezterm.log_info("Selected background: " .. selected)
  return selected
end

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

  -- 背景画像設定
  -- assetsディレクトリからランダムに画像を選択
  local background_image = select_random_background()

  if background_image then
    config.window_background_image = background_image

    -- 背景画像の見え方を調整（うっすら見えるように）
    config.window_background_image_hsb = {
      brightness = 0.05, -- 明るさ（0.0-1.0、低いほど暗い）
      hue = 1.0, -- 色相（1.0で元の色）
      saturation = 0.8, -- 彩度（1.0で元の彩度）
    }
  end

  -- 固定の背景画像を使いたい場合は以下のコメントを解除
  -- config.window_background_image = wezterm.home_dir .. "/.config/wezterm/background.jpg"

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
