#!/bin/sh
# 获取genpac工具
if ! type genpac >/dev/null 2>&1; then
  python3 -m pip install genpac --upgrade
  if [ $? -ne 0 ]; then
    echo "Install genpac failed!"
    exit 1
  fi
fi
# 生成AutoProxy.pac文件
LIST_GEN=./pac/list_gen.py
#LIST_OPTS="--bypass"
USER_LIST=./pac/user-rules.txt
GFW_LIST=https://cdn.jsdelivr.net/gh/gfwlist/tinylist@master/tinylist.txt
#GFW_LIST=https://cdn.jsdelivr.net/gh/gfwlist/gfwlist@master/gfwlist.txt
LIST_FILE=$([ "$LIST_OPTS" == "--bypass" ] && echo "../LocalProxy/bypass.txt" || echo "../LocalProxy/proxy.txt")

pushd "$(cd "$(dirname "$0")"; pwd)" >/dev/null 2>&1
$LIST_GEN --format=gost --output="$LIST_FILE" --gfwlist-url="$GFW_LIST" --user-rule-from="$USER_LIST"
if [ $? -ne 0 ]; then
  echo "Execute genpac failed!"
  popd >/dev/null 2>&1
  exit 2
fi

popd >/dev/null 2>&1
echo "Build '$LIST_FILE' success."

