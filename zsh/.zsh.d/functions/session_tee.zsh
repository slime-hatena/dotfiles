function session_tee() {
  DATE=$(date "+%Y-%m-%d-%W_%H-%M-%S")
  DIR="~/Development/local/logs"
  FILE_NAME="$DIR/$DATE.log"

  mkdir -p $DIR
  touch ${FILE_NAME}
  tmux pipe-pane "cat >> ${FILE_NAME}"

  echo "Session tail: ${FILE_NAME}"
  if [ ! -e ${FILE_NAME} ]; then
    echo ファイル作成に失敗しました。
  fi
}
