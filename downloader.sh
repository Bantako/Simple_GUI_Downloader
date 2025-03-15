#!/bin/bash

# シンプルなGUIダウンローダ（yadとaria2cを使用）

# テストモードかどうかを確認
TEST_MODE=false
if [ "$1" = "--test" ]; then
    TEST_MODE=true
    FORM="http://speedtest.tele2.net/10MB.zip|testfile.zip|ダウンロード|TRUE"
else
    # ダウンロード情報を入力
    FORM=$(yad --title="ダウンローダ" --text="ダウンロード情報を入力" --form --width=400 \
        --field="ダウンロードURL" "" \
        --field="保存ファイル名" "" \
        --field="保存先ディレクトリ:CB" "ダウンロード!デスクトップ!ドキュメント!その他" \
        --field="自動リトライを有効にする:CHK" TRUE)
fi

# キャンセルされた場合は終了
if [ -z "$FORM" ]; then
    exit 0
fi

# フォームの結果を分割
IFS='|' read -r URL FILENAME SELECTED ENABLE_RETRY <<< "$FORM"

# ファイル名が空白の場合、日時をファイル名にする
if [ -z "$FILENAME" ]; then
    FILENAME="download_$(date +'%Y%m%d_%H%M%S')"
fi

# リトライ設定
MAX_RETRIES=5
RETRY_WAIT=10

# 選択に応じてディレクトリを設定
case "$SELECTED" in
    "デスクトップ")
        DOWNLOAD_DIR=$(xdg-user-dir DESKTOP)
        ;;
    "ダウンロード")
        DOWNLOAD_DIR=$(xdg-user-dir DOWNLOAD)
        ;;
    "ドキュメント")
        DOWNLOAD_DIR=$(xdg-user-dir DOCUMENTS)
        ;;
    "その他")
        DOWNLOAD_DIR=$(yad --file --title="ダウンロード先ディレクトリを選択" --directory --width=600 --height=400)
        if [ $? -ne 0 ] || [ -z "$DOWNLOAD_DIR" ]; then
            exit 0
        fi
        ;;
    *)
    yad --error --title="エラー" --text="無効な選択です" --width=400
        exit 1
        ;;
esac

# aria2cで分割ダウンロード実行（指定ディレクトリに保存）
# 最大5回までリトライ、リトライ間隔は10秒
if [ "$ENABLE_RETRY" = "TRUE" ]; then
    aria2c -d "$DOWNLOAD_DIR" -o "$FILENAME" -x 16 -s 16 --max-tries="$MAX_RETRIES" --retry-wait="$RETRY_WAIT" "$URL"
else
    aria2c -d "$DOWNLOAD_DIR" -o "$FILENAME" -x 16 -s 16 "$URL"
fi

# ダウンロード結果を表示
if [ $? -eq 0 ]; then
    # 実際にダウンロードされたファイル名を取得
    ACTUAL_FILENAME=$(ls "$DOWNLOAD_DIR" | grep -E "^$FILENAME(|\.\d+)$" | sort | tail -n 1)
    yad --info --title="ダウンロード完了" --text="ダウンロードが完了しました\n保存先: $DOWNLOAD_DIR\nファイル名: $ACTUAL_FILENAME" --width=400
else
    ERROR_LOG=$(aria2c -d "$DOWNLOAD_DIR" -o "$FILENAME" -x 16 -s 16 "$URL" 2>&1)
    yad --error --title="ダウンロード失敗" --text="ダウンロードに失敗しました\n\nURL: $URL\n保存先: $DOWNLOAD_DIR\nエラー内容:\n$ERROR_LOG" --width=500
fi
