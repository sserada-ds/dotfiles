# Level 3 Tools Guide - 快適性向上ツール

最優先で導入すべき快適性向上ツールの使い方ガイド

## glow - Markdownビューア

READMEやドキュメントをターミナルで美しく表示します。

### 基本的な使い方

```bash
# ファイルを表示
glow README.md
md README.md  # エイリアス

# カレントディレクトリのMarkdownを検索
glow -p .

# 特定のディレクトリを検索
glow -p ~/projects
```

### ページャーモード

```bash
# ページャーとして使用（長いファイル）
glow -p README.md

# スタイル変更
glow -s dark README.md
glow -s light README.md
```

### 実用例

```bash
# プロジェクトのREADMEをすぐ確認
cd ~/projects/myapp
glow README.md

# GitHub風スタイルで表示
glow -s auto CONTRIBUTING.md

# すべてのMarkdownを検索
glow -p ~/Documents

# 標準入力から読み込み
echo "# Hello\nThis is **bold**" | glow -
```

### 便利なエイリアス

```bash
# すでに設定済み
md README.md  # glow README.md

# 追加で設定したい場合
alias docs='glow -p .'
alias readme='glow README.md'
```

---

## tokei - コード統計

プロジェクトのコード行数を言語別に集計します。

### 基本的な使い方

```bash
# カレントディレクトリの統計
tokei

# 特定のディレクトリ
tokei ~/projects/myapp

# 特定の言語のみ
tokei --type rust
tokei -t python
```

### ソート

```bash
# 行数でソート
tokei --sort lines

# ファイル数でソート
tokei --sort files

# コード行数でソート
tokei --sort code

# 降順
tokei --sort lines --reverse
```

### 出力形式

```bash
# JSON形式
tokei --output json

# YAML形式
tokei --output yaml

# ファイル名を含めて詳細表示
tokei --files
```

### 実用例

```bash
# プロジェクト規模を把握
cd ~/projects/myapp
tokei

# 複数プロジェクトを比較
tokei ~/projects/app1 ~/projects/app2

# 特定の拡張子を除外
tokei --exclude "*.test.js" --exclude "*.spec.ts"

# Gitignoreされたファイルも含める
tokei --hidden

# コンパクト表示
tokei --compact
```

### CI/CDでの活用

```bash
# JSONで出力してjqで加工
tokei --output json | jq '.Total.code'

# ベースラインとの比較
tokei --output json > current.json
# (変更後)
tokei --output json > after.json
diff <(jq .Total.code current.json) <(jq .Total.code after.json)
```

---

## dust - ディスク使用量

ディスク使用量を視覚的なツリーで表示します。

### 基本的な使い方

```bash
# カレントディレクトリ
dust

# 特定のディレクトリ
dust ~/projects

# ホームディレクトリ全体
dust ~
```

### 表示深度

```bash
# 深度1（直下のみ）
dust -d 1

# 深度2
dust -d 2

# 深度3（デフォルト）
dust -d 3

# すべて表示
dust -d 0
```

### ソートとフィルタ

```bash
# サイズでソート（デフォルト）
dust

# 名前でソート
dust -n

# 逆順
dust -r

# 件数制限
dust -n 10  # 上位10件のみ
```

### その他のオプション

```bash
# 隠しファイルも表示
dust -a

# 数値を人間が読みやすい形式で
dust -b  # バイト単位
dust -k  # KB単位
dust -m  # MB単位
dust -g  # GB単位

# パーセンテージ非表示
dust -p
```

### 実用例

```bash
# 大きなディレクトリを見つける
dust -d 1 ~/projects

# node_modulesを探す
dust | grep node_modules

# 特定のディレクトリのサイズ比較
dust -d 1 ~/projects/app1 ~/projects/app2

# ディスク容量圧迫の調査
dust -d 2 ~

# 最も大きいファイル/ディレクトリを特定
dust -d 1 / | head -20
```

### duとの比較

```bash
# 従来のdu
du -h -d 1 ~/projects | sort -hr

# dust（より見やすい）
dust -d 1 ~/projects
```

---

## bottom - システムモニター

topやhtopの現代的な代替品。CPU、メモリ、ネットワークを視覚的に表示します。

### 基本的な使い方

```bash
# 起動（終了はq）
btm
bottom

# topの代わり
top  # エイリアス設定済み
htop # エイリアス設定済み
```

### 表示モード

```bash
# デフォルトモード（全情報）
btm

# CPUのみ
btm --basic

# 特定のプロセスのみ
btm --regex "chrome"

# ツリー表示
btm --tree
```

### インタラクティブ操作

起動後のキーバインド：
| キー | 動作 |
|------|------|
| `Tab` / `Shift+Tab` | ウィジェット切り替え |
| `↑` `↓` | 項目選択 |
| `Enter` | プロセス詳細 |
| `dd` | プロセス終了（kill） |
| `c` | CPU使用率でソート |
| `m` | メモリ使用率でソート |
| `p` | PIDでソート |
| `n` | 名前でソート |
| `/` | 検索 |
| `?` | ヘルプ |
| `q` | 終了 |

### 実用例

```bash
# CPUを多く使うプロセスを確認
btm

# メモリリークを調査
btm --mem_utilization

# ネットワーク使用量を監視
btm --network_use_binary_prefix

# 特定のアプリのみ表示
btm --regex "node|python"
```

---

## procs - プロセス一覧

psの改良版。カラフルで読みやすい出力。

### 基本的な使い方

```bash
# 全プロセス表示
procs
pps  # エイリアス

# 特定のプロセスを検索
procs chrome
procs python

# ツリー表示
procs --tree
```

### ソートとフィルタ

```bash
# CPU使用率でソート
procs --sortd cpu

# メモリ使用率でソート
procs --sortd mem

# 特定ユーザーのプロセス
procs --user $(whoami)

# 実行時間でソート
procs --sortd time
```

### 表示カスタマイズ

```bash
# 特定カラムのみ表示
procs --only pid,user,cpu,mem,name

# 詳細表示
procs --watch

# JSON形式
procs --json
```

### 実用例

```bash
# メモリを多く使うプロセスTop 10
procs --sortd mem | head -11

# 特定のポートを使っているプロセス
lsof -i :3000

# 長時間実行中のプロセス
procs --sortd time

# 自分のプロセスのみ
procs --user $(whoami)
```

---

## sd - 直感的な置換

sedの代替品。より直感的な構文。

### 基本的な使い方

```bash
# 文字列置換
echo "hello world" | sd "world" "universe"

# ファイル内置換（直接書き換え）
sd "old" "new" file.txt

# 複数ファイル
sd "old" "new" *.txt
```

### 正規表現

```bash
# 数字を削除
echo "test123" | sd '\d+' ''

# グループ参照
echo "2024-01-26" | sd '(\d{4})-(\d{2})-(\d{2})' '$3/$2/$1'

# 大文字小文字を無視
sd -i "error" "ERROR" log.txt
```

### 実用例

```bash
# import文の一括変更
sd 'import \* from' 'import' **/*.js

# URLの一括変更
sd 'http://' 'https://' *.html

# 改行コード変更
sd '\r\n' '\n' file.txt

# 先頭の空白を削除
sd '^\s+' '' file.txt

# ファイル名の一括変更（renameと組み合わせ）
for f in *.txt; do
  mv "$f" "$(echo $f | sd 'old' 'new')"
done
```

### sedとの比較

```bash
# sed（複雑）
sed -i '' 's/old/new/g' file.txt

# sd（シンプル）
sd 'old' 'new' file.txt
```

---

## just - タスクランナー

makeの現代的な代替品。プロジェクトのタスクを管理します。

### セットアップ

プロジェクトルートに`justfile`を作成：

```just
# デフォルトレシピ（just実行時）
default:
  @just --list

# テスト実行
test:
  npm test

# ビルド
build:
  npm run build

# 開発サーバー起動
dev:
  npm run dev

# 依存関係インストール
install:
  npm install

# クリーンアップ
clean:
  rm -rf dist node_modules
```

### 基本的な使い方

```bash
# レシピ一覧表示
just --list
just -l

# レシピ実行
just test
just build

# 引数付きレシピ
# justfile: greet name:
#   @echo "Hello, {{name}}!"
just greet World
```

### 高度な機能

```bash
# 変数使用
# justfile:
# version := "1.0.0"
# release:
#   echo "Releasing {{version}}"

# 条件分岐
# justfile:
# test os:
#   @if [ "{{os}}" = "macos" ]; then echo "Mac"; fi

# 依存関係
# justfile:
# build: install
#   npm run build
```

### 実用例

```bash
# プロジェクト全体の操作を一元管理
just setup     # 初期セットアップ
just test      # テスト
just deploy    # デプロイ

# Makefileより直感的
just format    # コードフォーマット
just lint      # リンター実行
just docker-up # Docker起動
```

---

## watchexec - ファイル監視

ファイル変更時に自動的にコマンドを実行します。

### 基本的な使い方

```bash
# ファイル変更時にコマンド実行
watchexec echo "Changed!"

# 特定の拡張子のみ監視
watchexec --exts js,ts npm test

# 特定のファイルを監視
watchexec --watch src npm run build
```

### 実用例

```bash
# テストの自動実行
watchexec --clear --exts rs cargo test

# ビルドの自動実行
watchexec --exts js,jsx,ts,tsx npm run build

# サーバーの自動再起動
watchexec --restart --exts py python server.py

# Markdownプレビュー
watchexec --exts md glow README.md

# 複数コマンド実行
watchexec --exts js "npm run lint && npm test"
```

### オプション

```bash
# 変更時に画面クリア
watchexec --clear command

# デバウンス（連続変更を防ぐ）
watchexec --debounce 2000 command  # 2秒待つ

# 無視パターン
watchexec --ignore "*.log" --ignore "node_modules" command

# 初回実行しない
watchexec --postpone command

# プロセス再起動
watchexec --restart command
```

---

## duf - ディスク容量

dfの改良版。視覚的で読みやすいディスク使用量表示。

### 基本的な使い方

```bash
# 全ドライブ表示
duf
df  # エイリアス

# 特定のマウントポイント
duf /home

# JSON形式
duf --json
```

### 表示オプション

```bash
# ソート
duf --sort size

# 特定のファイルシステムタイプのみ
duf --only local

# ネットワークドライブを除外
duf --hide-fs nfs,cifs

# 詳細表示
duf --all
```

### 実用例

```bash
# システム全体の容量確認
duf

# 特定ディレクトリのサイズ
du -sh /path/to/dir  # 従来の方法
dust /path/to/dir    # より詳細（Level 3の別ツール）

# ディスク使用率アラート
if duf --json | jq '.[0].usage.percent' | awk '$1 > 90'; then
  echo "Disk usage critical!"
fi
```

---

## 組み合わせ活用例

### プロジェクト分析ワークフロー

```bash
# 1. READMEを確認
cd ~/projects/myapp
glow README.md

# 2. コード規模を把握
tokei

# 3. ディスク使用量を確認
dust -d 2

# 4. 大きなディレクトリを特定
dust -d 1 | head -10
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

### ドキュメント管理

```bash
# すべてのREADMEを一覧
find . -name "README.md" -exec echo {} \; -exec glow {} \;

# プロジェクトのドキュメント検索
glow -p ~/projects

# ドキュメント化されていないプロジェクトを見つける
for dir in ~/projects/*/; do
  if [ ! -f "$dir/README.md" ]; then
    echo "No README: $dir"
  fi
done
```

### コード統計レポート

```bash
# プロジェクト別統計
for dir in ~/projects/*/; do
  echo "=== $(basename $dir) ==="
  tokei "$dir"
done

# 言語別集計
tokei --type rust ~/projects
tokei --type python ~/projects
tokei --type typescript ~/projects

# CSV形式で出力
tokei --output json | jq -r '.Total | [.language, .files, .code, .comments, .blanks] | @csv'
```

### システム監視ワークフロー

```bash
# 1. システムリソースを確認
btm  # CPUとメモリを視覚的に確認

# 2. 重いプロセスを特定
procs --sortd mem | head -20

# 3. ディスク容量を確認
duf

# 4. 特定ディレクトリのサイズを詳細表示
dust -d 2 ~/projects
```

### 開発ワークフロー自動化

```bash
# 1. justfileでタスク定義
cat > justfile <<'EOF'
dev:
  watchexec --exts js,jsx npm run dev

test-watch:
  watchexec --clear --exts js,jsx npm test

format:
  prettier --write .
EOF

# 2. 開発サーバーを自動再起動
just dev

# 3. テストを自動実行
just test-watch
```

### 一括ファイル編集

```bash
# 1. 現状確認
tokei src/

# 2. import文を一括変更
sd 'import React from "react"' 'import { React } from "react"' src/**/*.jsx

# 3. 変更結果を確認
git diff

# 4. プロジェクト統計を再確認
tokei src/
```

### パフォーマンス調査

```bash
# 1. システム全体の状態
btm

# 2. 特定プロセスの詳細
procs chrome

# 3. ディスク使用量を確認
duf && dust -d 1 ~

# 4. 不要なファイルを削除
# (慎重に！)
```

---

## Tips

### エイリアス設定

```bash
# ~/.zshrcまたは~/.zsh/alias.zshに追加（既に設定済み）
alias md='glow'              # Markdown表示
alias top='btm'              # システムモニター
alias htop='btm'             # システムモニター
alias pps='procs'            # プロセス一覧
alias df='duf'               # ディスク容量

# 追加で設定したい場合
alias stats='tokei && dust -d 1'
alias readme='glow README.md'
alias docs='glow -p .'
alias big='dust -d 1 | head -20'
alias monitor='btm'
alias processes='procs --sortd mem'
```

### カラースキーム

```bash
# glowのテーマ変更
glow -s dark README.md
glow -s light README.md
glow -s auto README.md  # 自動判定
```

### パフォーマンス

- **tokei**: 大規模プロジェクトでも数秒
- **dust**: 数百GBでも高速
- **glow**: 即座にレンダリング

### 除外パターン

```bash
# tokei: .gitignoreを尊重
tokei  # 自動的にnode_modules等を除外

# dust: 隠しファイルを含める
dust -a

# glow: 特定のファイルのみ
glow README.md CONTRIBUTING.md
```

---

## よくある使い方

### 新しいプロジェクトに参加したとき

```bash
# 1. READMEを読む
glow README.md

# 2. プロジェクトの規模を把握
tokei

# 3. ディレクトリ構造を確認
dust -d 2
```

### プロジェクトのクリーンアップ

```bash
# 1. 現在のサイズ
dust -d 1

# 2. 大きなディレクトリを特定
dust -d 2 | grep -E "node_modules|target|dist"

# 3. 不要なものを削除
# ...

# 4. 削減量確認
dust -d 1
```

### ドキュメント作成

```bash
# 1. Markdownを書く
nvim README.md

# 2. プレビュー
glow README.md

# 3. 修正
nvim README.md

# 4. 再プレビュー
glow README.md
```

### コード統計レポート作成

```bash
# プロジェクトの統計をファイルに保存
tokei --output json > stats.json
tokei > stats.txt

# グラフ化（別ツール連携）
tokei --output json | jq '.Total'
```
