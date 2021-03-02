#!/bin/sh
# 下载、解压文件，并拷贝到源码目录下
function zip_file() {
  src=$SOURCE_PATH/$1
  dst=$TARGET_PATH/$2
  echo Packaging zip "$dst"...
  rm -fr $dst
  pushd "$src" >/dev/null 2>&1
  zip -r $dst *
  popd >/dev/null 2>&1
}
# 获取脚本目录
SOURCE_PATH=$(cd "$(dirname "$0")"; pwd)
TARGET_PATH=$(cd "$SOURCE_PATH/.."; pwd)
# 依次打包相关目录
zip_file "GadgetBinary" "GadgetBinary/GadgetBinary.zip"
for path in `ls "$SOURCE_PATH/GadgetConfig"`; do
  if [ -d "$SOURCE_PATH/GadgetConfig/$path" ]; then
    zip_file "GadgetConfig/$path" "GadgetConfig/$path.zip"
  fi
done
echo Package group control files success.
