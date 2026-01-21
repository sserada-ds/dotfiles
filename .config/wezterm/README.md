# WezTerm 設定ガイド

WezTermはRustで書かれたGPUアクセラレーション対応のターミナルエミュレータです。

## 目次

- [特徴](#特徴)
- [インストール](#インストール)
- [設定内容](#設定内容)
- [キーバインド](#キーバインド)
- [カスタマイズ](#カスタマイズ)
- [トラブルシューティング](#トラブルシューティング)

---

## 特徴

### なぜWezTermを選ぶのか？

- **高速**: GPUアクセラレーションによる高速レンダリング
- **クロスプラットフォーム**: macOS、Linux、Windows対応
- **Lua設定**: 柔軟で強力なLuaスクリプトによる設定
- **マルチプレクサ内蔵**: tmuxのような機能を内蔵（ペイン分割、タブ管理）
- **リガチャ対応**: プログラミング用フォントのリガチャに対応
- **Unicode対応**: 絵文字やNerd Fontsアイコンの完全サポート

---

## インストール

### macOS (Homebrew)

```bash
brew install --cask wezterm
```

### 設定ファイルの適用

このdotfilesリポジトリを使用している場合:

```bash
# dotfilesディレクトリで実行
make install-links
```

手動でシンボリックリンクを作成する場合:

```bash
ln -sf ~/.dotfiles/.config/wezterm ~/.config/wezterm
```

---

## 設定内容

### フォント設定

- **メインフォント**: JetBrains Mono (Medium)
- **日本語フォールバック**: HackGen Console NF
- **フォントサイズ**: 13.0pt
- **行間**: 1.1（読みやすさ向上）

### カラースキーム

- **Gruvbox dark, hard (base16)** - Neovimと統一

### ウィンドウ設定

- **背景透過度**: 92%
- **背景ぼかし**: 有効（macOS）
- **ウィンドウ装飾**: タイトルバー非表示（RESIZE）
- **パディング**: 上下左右 8px

### タブバー

- 1つのタブのみの場合は非表示
- シンプルなタブバースタイル
- 上部配置

### ペイン

- 非アクティブなペインは彩度80%、輝度70%に暗く表示
- アクティブなペインが一目で分かる

### パフォーマンス

- **レンダリングバックエンド**: WebGPU
- **最大FPS**: 120fps
- **スクロールバック**: 10,000行

---

## キーバインド

### ペイン操作

| キー            | 説明                       |
| --------------- | -------------------------- |
| `Cmd+d`         | ペインを水平分割           |
| `Cmd+Shift+d`   | ペインを垂直分割           |
| `Cmd+h/j/k/l`   | ペイン間を移動（vim風）    |
| `Cmd+w`         | 現在のペインを閉じる       |
| `Cmd+z`         | ペインをズーム（全画面化） |

### タブ操作

| キー          | 説明             |
| ------------- | ---------------- |
| `Cmd+t`       | 新しいタブを開く |
| `Cmd+[`       | 前のタブへ移動   |
| `Cmd+]`       | 次のタブへ移動   |
| `Cmd+1~9`     | タブ番号で移動   |

### その他

| キー              | 説明                         |
| ----------------- | ---------------------------- |
| `Cmd+Shift+r`     | 設定ファイルをリロード       |
| `Cmd+クリック`    | URLをブラウザで開く          |

---

## カスタマイズ

### フォントを変更する

`wezterm.lua`の以下の部分を編集:

```lua
config.font = wezterm.font_with_fallback({
  { family = "お好みのフォント", weight = "Medium" },
  { family = "日本語フォント", weight = "Regular" },
})
config.font_size = 14.0  -- サイズも変更可能
```

### カラースキームを変更する

利用可能なカラースキームを確認:

```bash
wezterm ls-fonts --list-colors
```

設定ファイルで変更:

```lua
config.color_scheme = "Tokyo Night"  -- 例
```

### 透過度を調整する

```lua
config.window_background_opacity = 0.95  -- 0.0（完全透明）～ 1.0（不透明）
```

### キーバインドを追加する

`config.keys`テーブルに追加:

```lua
{
  key = "n",
  mods = "CMD|SHIFT",
  action = wezterm.action.SpawnWindow,
},
```

### OS別の設定を追加する

```lua
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- Windows専用設定
elseif wezterm.target_triple:find("darwin") then
  -- macOS専用設定
else
  -- Linux専用設定
end
```

---

## トラブルシューティング

### フォントが正しく表示されない

1. フォントがインストールされているか確認:
   ```bash
   wezterm ls-fonts
   ```

2. 設定ファイルでフォント名を確認（正確な名前が必要）

### 日本語入力ができない

`wezterm.lua`で以下が設定されているか確認:

```lua
config.use_ime = true
```

### 設定が反映されない

1. 設定ファイルのパスを確認:
   ```bash
   ls -la ~/.config/wezterm/wezterm.lua
   ```

2. 構文エラーをチェック:
   ```bash
   wezterm --config-file ~/.config/wezterm/wezterm.lua start
   ```

3. 設定をリロード: `Cmd+Shift+r`

### パフォーマンスが悪い

1. フロントエンドを変更:
   ```lua
   config.front_end = "OpenGL"  -- WebGpuの代わりに
   ```

2. FPSを下げる:
   ```lua
   config.max_fps = 60
   ```

### tmuxとの併用

WezTermはマルチプレクサ機能を内蔵しているため、tmuxは基本的に不要です。ただし、tmuxを使いたい場合は普通に`tmux`コマンドで起動できます。

WezTermのペイン機能とtmuxのペイン機能は競合しないため、両方を同時に使うこともできます。

---

## 参考リンク

- [WezTerm 公式ドキュメント](https://wezterm.org/)
- [WezTerm Configuration](https://wezterm.org/config/files.html)
- [WezTerm Lua API Reference](https://wezterm.org/config/lua/general.html)
- [GitHub - wez/wezterm](https://github.com/wez/wezterm)

---

## 設定ファイルの構造

```
.config/wezterm/
├── wezterm.lua           # メイン設定ファイル
└── README.md             # このファイル
```

より複雑な設定が必要な場合は、設定を複数のファイルに分割できます:

```
.config/wezterm/
├── wezterm.lua           # メイン設定
├── keybinds.lua          # キーバインド
├── colors.lua            # カラー設定
└── utils.lua             # ユーティリティ関数
```

分割した設定を読み込む例:

```lua
-- wezterm.lua
local wezterm = require("wezterm")
local keybinds = require("keybinds")

local config = wezterm.config_builder()
keybinds.apply_to_config(config)
return config
```
