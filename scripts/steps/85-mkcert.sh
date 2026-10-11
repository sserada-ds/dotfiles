# desc: mkcert ルート CA 登録 (localhost HTTPS 用。管理者パスワードが必要)
# default: on

run() {
  if ! has mkcert; then
    err "mkcert が見つかりません。先に deps を実行してください"
    return 1
  fi
  if confirm "mkcert のローカル CA を登録しますか？"; then
    mkcert -install
    ok "CA 登録完了 (例: mkcert localhost 127.0.0.1 ::1)"
  else
    skip "CA 登録 (後で: mkcert -install)"
  fi
}
