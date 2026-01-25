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

---

## Tips

### エイリアス設定

```bash
# ~/.zshrcまたは~/.zsh/alias.zshに追加
alias stats='tokei && dust -d 1'
alias readme='glow README.md'
alias docs='glow -p .'
alias big='dust -d 1 | head -20'
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
