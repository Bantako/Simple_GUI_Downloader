#!/bin/bash

# シンプルなGUIダウンローダ（zenityとaria2cを使用）

# URLとファイル名を一度に入力
FORM=$(zenity --forms --title="ダウンローダ" --text="ダウンロード情報を入力" --width=400 \
    --add-entry="ダウンロードURL" \
    --add-entry="保存ファイル名")

# キャンセルされた場合は終了
if [ -z "$FORM" ]; then
    exit 0
fi

# フォームの結果を分割
URL=$(echo "$FORM" | awk -F'|' '{print $1}')
FILENAME=$(echo "$FORM" | awk -F'|' '{print $2}')

# ここにaria2cを使ったダウンロード処理を追加予定

echo "URL: $URL"
echo "ファイル名: $FILENAME"
