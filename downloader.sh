#!/bin/bash

# シンプルなGUIダウンローダ（zenityとaria2cを使用）

# ダウンロード情報を入力
FORM=$(zenity --forms --title="ダウンローダ" --text="ダウンロード情報を入力" --width=400 \
    --add-entry="ダウンロードURL" \
    --add-entry="保存ファイル名" \
    --add-combo="保存先ディレクトリ" \
    --combo-values="デスクトップ|ダウンロード|ドキュメント|その他")

# キャンセルされた場合は終了
if [ -z "$FORM" ]; then
    exit 0
fi

# フォームの結果を分割
URL=$(echo "$FORM" | awk -F'|' '{print $1}')
FILENAME=$(echo "$FORM" | awk -F'|' '{print $2}')
SELECTED=$(echo "$FORM" | awk -F'|' '{print $3}')

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
        DOWNLOAD_DIR=$(zenity --file-selection --title="ダウンロード先ディレクトリを選択" --directory)
        if [ -z "$DOWNLOAD_DIR" ]; then
            exit 0
        fi
        ;;
    *)
        zenity --error --title="エラー" --text="無効な選択です" --width=400
        exit 1
        ;;
esac

# aria2cで分割ダウンロード実行（指定ディレクトリに保存）
aria2c -d "$DOWNLOAD_DIR" -o "$FILENAME" -x 16 -s 16 "$URL"

# ダウンロード結果を表示
if [ $? -eq 0 ]; then
    zenity --info --title="ダウンロード完了" --text="ダウンロードが完了しました\n保存先: $DOWNLOAD_DIR\nファイル名: $FILENAME" --width=400
else
    zenity --error --title="ダウンロード失敗" --text="ダウンロードに失敗しました" --width=400
fi
