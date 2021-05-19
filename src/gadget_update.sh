#!/bin/sh
# 获取脚本目录
PROJECT_HOME=$(cd "$(dirname "$0")"; pwd)
TARGET_PATH=./GadgetBinary
# "-help": 显示帮助信息并退出
if [ "$1" == "help" -o "$1" == "-h" -o "$1" == "-help" ]; then
  echo "$0 -help     Show this help message."
  echo "$0 [version] Download frdia gadget from github into '$TARGET_PATH'."
  exit -1
fi
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
  mv -f "$dst.so" "$PROJECT_HOME/$TARGET_PATH"
  if [ $? -ne 0 ]; then
    rm -f "$dst.so"
    echo Move "$dst.so" failed!
    exit 3
  fi
}

# 下载版本号
if [ $1 ]; then VERSION=$1; else VERSION=$(python3 -m pip install frida --upgrade > /dev/null && frida --version); fi

# 依次下载相关文件
download "android-arm" "lib-tweak32"
download "android-arm64" "lib-tweak64"

# 保存当前版本号到源码目录
echo $VERSION > "$PROJECT_HOME/$TARGET_PATH/lib-tweak.version"

echo Update 'lib-tweak32.so' and 'lib-tweak64.so' success.
