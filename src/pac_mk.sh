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
LOCAL_PROXY="SOCKS5 127.0.0.1:1080"
PAC_FILE=../LocalProxy/AutoProxy.pac
GFW_LIST=https://cdn.jsdelivr.net/gh/gfwlist/tinylist@master/tinylist.txt
#GFW_LIST=https://cdn.jsdelivr.net/gh/gfwlist/gfwlist@master/gfwlist.txt
USER_LIST=./pac/user-rules.txt

pushd "$(cd "$(dirname "$0")"; pwd)" >/dev/null 2>&1
genpac --pac-proxy "$LOCAL_PROXY" --output="$PAC_FILE" --gfwlist-url="$GFW_LIST" --user-rule-from="$USER_LIST"
if [ $? -ne 0 ]; then
  echo "Install genpac failed!"
  popd >/dev/null 2>&1
  exit 2
fi

popd >/dev/null 2>&1
echo "Build '$PAC_FILE' success."

