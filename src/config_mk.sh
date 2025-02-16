#!/bin/sh
# 获取脚本目录
SOURCE_PATH=$(cd "$(dirname "$0")"; pwd)
TARGET_PATH=../GadgetConfig
# "-help": 显示帮助信息并退出
if [ "$1" == "help" -o "$1" == "-h" -o "$1" == "-help" ]; then
  echo "$0 -help Show this help message."
  echo "$0       Generate zip files of gadget config into '$TARGET_PATH'."
  exit -1
fi
# 下载、解压文件，并拷贝到源码目录下
function zip_file() {
  src=$1
  dst=$2
  echo Packaging zip "$dst"...
  rm -fr $dst
  pushd "$src" >/dev/null 2>&1
  zip -r $dst *
  popd >/dev/null 2>&1
}
# 依次打包相关目录
for path in `ls "$SOURCE_PATH/GadgetConfig"`; do
  if [ -d "$SOURCE_PATH/GadgetConfig/$path" ]; then
    zip_file "$SOURCE_PATH/GadgetConfig/$path" "$SOURCE_PATH/$TARGET_PATH/$path.zip"
  fi
done

echo Generate zip files of gadget control success.
