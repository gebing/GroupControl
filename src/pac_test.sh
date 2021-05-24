#!/bin/sh
# "-help": 显示帮助信息并退出
if [ "$1" == "help" -o "$1" == "-h" -o "$1" == "-help" -o "$1" == "" ]; then
  echo "$0 url"
  exit 0
fi
# 测试AutoProxy.pac文件
PAC_FILE=$(cd "$(dirname "$0")"/../LocalProxy; pwd)/AutoProxy.pac
echo "Testing pac file '$PAC_FILE' for url '$1'..."
pactester -p "$PAC_FILE" -u "$1"
