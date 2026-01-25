# direnv - ディレクトリ別環境変数管理
# プロジェクトごとに.envrcファイルで環境変数を自動設定

# direnvが利用可能な場合のみ有効化
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi
