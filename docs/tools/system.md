# System Tools

システム監視・管理ツール

---

## システム監視

### bottom

topやhtopの現代的な代替品。

**使い方:**

```bash
# 起動
btm
top    # エイリアス
htop   # エイリアス

# CPUのみ
btm --basic

# 特定のプロセスのみ
btm --regex "chrome"

# ツリー表示
btm --tree
```

**キーバインド:**

| キー | 動作 |
|------|------|
| `Tab` / `Shift+Tab` | ウィジェット切り替え |
| `↑` `↓` | 項目選択 |
| `dd` | プロセス終了（kill） |
| `c` | CPU使用率でソート |
| `m` | メモリ使用率でソート |
| `/` | 検索 |
| `?` | ヘルプ |
| `q` | 終了 |

### procs

psの改良版。

**使い方:**

```bash
# 全プロセス表示
procs
pps  # エイリアス

# 特定のプロセスを検索
procs chrome
procs python

# CPU使用率でソート
procs --sortd cpu

# メモリ使用率でソート
procs --sortd mem

# ツリー表示
procs --tree

# JSON形式
procs --json
```

---

## ディスク管理

### dust

ディスク使用量を視覚的なツリーで表示。

**使い方:**

```bash
# カレントディレクトリ
dust

# 特定のディレクトリ
dust ~/projects

# 深度指定
dust -d 1  # 直下のみ
dust -d 2

# 件数制限
dust -n 10  # 上位10件

# 隠しファイルも表示
dust -a
```

**実用例:**

```bash
# 大きなディレクトリを見つける
dust -d 1 ~/projects

# node_modulesを探す
dust | grep node_modules

# ディスク容量圧迫の調査
dust -d 2 ~
```

### duf

dfの改良版。視覚的で読みやすいディスク使用量表示。

**使い方:**

```bash
# 全ドライブ表示
duf
df  # エイリアス

# 特定のマウントポイント
duf /home

# ソート
duf --sort size

# JSON形式
duf --json
```

---

## ネットワーク

### bandwhich

ネットワーク帯域幅をプロセス別に可視化。

**使い方:**

```bash
# 起動（管理者権限が必要）
sudo bandwhich

# 特定のインターフェース
sudo bandwhich -i eth0
sudo bandwhich -i en0  # macOS WiFi
```

**キーバインド:**

| キー | 動作 |
|------|------|
| `Space` | 一時停止/再開 |
| `Tab` | 表示切り替え |
| `q` | 終了 |

### doggo

モダンなDNS lookupツール。

**使い方:**

```bash
# A レコード
doggo example.com

# MXレコード
doggo example.com MX

# すべてのレコード
doggo example.com ANY

# 短い出力
doggo example.com --short

# DNSサーバー指定
doggo example.com @8.8.8.8
doggo example.com @1.1.1.1

# DNS over HTTPS
doggo example.com @https://dns.google/dns-query

# JSON形式
doggo example.com --json
```

**実用例:**

```bash
# メールサーバー確認
doggo example.com MX

# ネームサーバー確認
doggo example.com NS

# TXTレコード（SPF等）
doggo example.com TXT

# IPv6アドレス
doggo example.com AAAA

# リバースDNS
doggo -x 8.8.8.8
```

---

## ユーティリティ

### pv

パイプラインの進捗を視覚化。

**使い方:**

```bash
# ファイルコピーの進捗表示
pv large-file.tar.gz | tar xz

# 圧縮の進捗
cat large-file | pv | gzip > output.gz

# データベースバックアップ
mysqldump db_name | pv > backup.sql

# サイズ指定
pv -s 1G large-file | dd of=/dev/sdb
```

### mkcert

ローカル開発用SSL証明書を簡単に生成。

**セットアップ:**

```bash
# ローカルCA作成（初回のみ）
mkcert -install

# 証明書生成
mkcert localhost 127.0.0.1 ::1
mkcert example.test

# カスタムドメイン
mkcert myapp.local
```

**実用例:**

```bash
# Next.js開発サーバー用
mkcert localhost

# カスタムドメイン開発
mkcert app.test api.test

# 複数ドメイン
mkcert example.test "*.example.test"
```

### zellij

モダンなターミナルマルチプレクサ（tmux代替）。

**使い方:**

```bash
# セッション開始
zellij

# 名前付きセッション
zellij -s mysession

# セッション一覧
zellij list-sessions

# セッションに接続
zellij attach mysession
```

**キーバインド:**

| キー | 動作 |
|------|------|
| `Ctrl+P` | ペイン操作モード |
| `Ctrl+T` | タブ操作モード |
| `Ctrl+N` | サイズ変更モード |
| `Ctrl+S` | スクロールモード |
| `Ctrl+Q` | セッション終了 |

**特徴:**

- レイアウトのビジュアル化
- プラグインシステム
- 設定がシンプル
- フローティングペイン

### silicon

コードを美しい画像に変換。

**使い方:**

```bash
# ファイルから画像生成
silicon main.rs -o output.png

# クリップボードから生成してクリップボードへ
silicon --from-clipboard --to-clipboard

# 標準入力から
echo 'console.log("Hello")' | silicon -l javascript -o output.png
```

**オプション:**

```bash
# テーマ指定
silicon main.rs --theme Dracula -o output.png
silicon main.rs --theme gruvbox-dark -o output.png

# テーマ一覧
silicon --list-themes

# 行番号
silicon main.rs --line-number -o output.png

# 開始行指定
silicon main.rs --line-offset 10 -o output.png

# 背景色
silicon main.rs --background '#1e1e1e' -o output.png
```

**実用例:**

```bash
# ブログ用のコードスクリーンショット
silicon blog-example.js --theme gruvbox-dark -o blog-code.png

# プレゼン用
silicon demo.py --line-number --theme Dracula -o presentation.png

# クリップボード経由でスクリーンショット
# 1. コードをコピー
# 2. silicon --from-clipboard --to-clipboard
# 3. 画像が自動的にクリップボードに

# GitHub README用
silicon example.sh --theme GitHub -o example.png
```

---

## コード統計

### tokei

プロジェクトのコード行数を言語別に集計。

**使い方:**

```bash
# カレントディレクトリの統計
tokei

# 特定のディレクトリ
tokei ~/projects/myapp

# 特定の言語のみ
tokei --type rust
tokei -t python

# ソート
tokei --sort lines
tokei --sort files

# JSON形式
tokei --output json

# ファイル名を含めて詳細表示
tokei --files
```

**実用例:**

```bash
# プロジェクト規模を把握
cd ~/projects/myapp
tokei

# 複数プロジェクトを比較
tokei ~/projects/app1 ~/projects/app2

# CI/CDで使用
tokei --output json | jq '.Total.code'

# 特定の拡張子を除外
tokei --exclude "*.test.js" --exclude "*.spec.ts"
```

---

## 実用的なワークフロー

### システム監視ワークフロー

```bash
# 1. システムリソースを確認
btm

# 2. 重いプロセスを特定
procs --sortd mem | head -20

# 3. ディスク容量を確認
duf

# 4. 特定ディレクトリのサイズを詳細表示
dust -d 2 ~/projects

# 5. ネットワーク使用量を確認
sudo bandwhich
```

### リポジトリクリーンアップ

```bash
# 1. 現状確認
dust -d 1

# 2. 不要なファイルを特定
dust -d 2 | grep -E "node_modules|dist|build|.cache"

# 3. 削除前のサイズ記録
dust -d 0 > before.txt

# 4. クリーンアップ
rm -rf node_modules dist build .cache

# 5. 削減量確認
dust -d 0 > after.txt
```

### ネットワークトラブルシューティング

```bash
# 1. DNS確認
doggo example.com
doggo example.com MX

# 2. 帯域幅使用量確認
sudo bandwhich

# 3. プロセス別ネットワーク使用量
procs --sortd cpu
```

### 開発用SSL証明書セットアップ

```bash
# 1. mkcertインストール確認
mkcert --version

# 2. ローカルCA作成
mkcert -install

# 3. 証明書生成
mkcert localhost 127.0.0.1 ::1

# 4. Next.js/Vite等で使用
# server.js で生成された証明書を指定
```
