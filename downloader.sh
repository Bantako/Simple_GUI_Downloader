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

# aria2cでダウンロード実行
aria2c -o "$FILENAME" "$URL"

# ダウンロード結果を表示
if [ $? -eq 0 ]; then
    zenity --info --title="ダウンロード完了" --text="ダウンロードが完了しました\nファイル名: $FILENAME" --width=400
else
    zenity --error --title="ダウンロード失敗" --text="ダウンロードに失敗しました" --width=400
fi
