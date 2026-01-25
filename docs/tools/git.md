# Git & GitHub Tools

Git操作とGitHub連携を強化するツール

---

## git-delta

Git差分を美しく表示します。

**特徴:**

- 構文ハイライト
- 行番号表示
- side-by-side表示（オプション）
- Gruvboxテーマ対応

**使い方:**

```bash
# 自動的に使用される（設定済み）
git diff
git diff --staged
git log -p
git show HEAD

# side-by-side表示
git -c delta.side-by-side=true diff

# 特定のファイルのみ
git diff path/to/file.js
```

**設定:**

`.gitconfig`に自動設定されます。カスタマイズは`git config`で：

```bash
git config --global delta.side-by-side true
git config --global delta.line-numbers false
```

---

## lazygit

Git操作のターミナルUI。

**起動:**

```bash
lazygit
lg  # エイリアス
```

**主要キーバインド:**
| キー | 動作 |
|------|------|
| `1-5` | パネル切り替え（Status, Files, Branches, Commits, Stash） |
| `space` | ステージング/アンステージング |
| `c` | コミット |
| `p` | プッシュ/プル |
| `P` | プッシュ（force） |
| `n` | 新規ブランチ作成 |
| `m` | マージ |
| `r` | リベース |
| `u` | アンドゥ（元に戻す） |
| `?` | ヘルプ |
| `q` | 終了 |

**便利な機能:**

- **ビジュアルdiff**: ファイルを選択してenterで詳細表示
- **インタラクティブrebase**: コミット選択して`e`
- **チェリーピック**: コミット選択して`c`
- **ステージング一部選択**: ファイル選択して`space`で行単位選択

---

## gh

GitHub公式CLI。

**認証:**

```bash
gh auth login
```

**PR操作:**

```bash
# PR作成
gh pr create

# PR一覧
gh pr list

# PRレビュー
gh pr view 123
gh pr review 123

# PRチェックアウト
gh pr checkout 123

# PRマージ
gh pr merge 123
```

**Issue操作:**

```bash
# Issue作成
gh issue create

# Issue一覧
gh issue list

# Issue詳細
gh issue view 123

# Issueクローズ
gh issue close 123
```

**リポジトリ操作:**

```bash
# リポジトリ情報
gh repo view

# リポジトリクローン
gh repo clone owner/repo

# リポジトリ作成
gh repo create my-new-repo

# Forkする
gh repo fork
```

**その他:**

```bash
# GitHub Actions実行状況
gh run list
gh run view 123

# Gistを作成
gh gist create file.txt

# リリース作成
gh release create v1.0.0
```
