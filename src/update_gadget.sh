#!/bin/sh
# 下载、解压文件，并拷贝到源码目录下
function download() {
  src=$1
  dst=$2
  wget --unlink -O "$dst.so.xz" https://github.com/frida/frida/releases/download/$VERSION/frida-gadget-$VERSION-$1.so.xz
  if [ $? -ne 0 ]; then
    rm -f "$dst.so.xz"
    echo Download "$dst.so.xz" failed!
    exit 1
  fi
  xz -d -f "$dst.so.xz"
  if [ $? -ne 0 ]; then
    rm -f "$dst.so.xz"
    echo Decompress "$dst.so.xz" failed!
    exit 2
  fi
  if [ "$GADGET_PATH" == "$PROJECT_HOME" ]; then
    return
  fi
  mv -f "$dst.so" $GADGET_PATH/
  if [ $? -ne 0 ]; then
    rm -f "$dst.so"
    echo Move "$dst.so" failed!
    exit 3
  fi
}

# 获取脚本目录和下载版本号
PROJECT_HOME=$(cd "$(dirname "$0")"; pwd)
GADGET_PATH=$PROJECT_HOME/GadgetBinary
if [ $1 ]; then VERSION=$1; else VERSION=$(python3 -m pip install frida --upgrade > /dev/null && frida --version); fi

# 依次下载相关文件
download "android-arm" "lib-tweak32"
download "android-arm64" "lib-tweak64"

# 保存当前版本号到源码目录
echo $VERSION > $GADGET_PATH/lib-tweak.version

echo Install 'lib-tweak32.so' and 'lib-tweak64.so' success.
