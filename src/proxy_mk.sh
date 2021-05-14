#!/bin/sh
GOST_VERSION=2.11.1
# 获取安卓NDK的CC编译器
if [ "$ANDROID_NDK_ROOT" == "" ]; then
  echo "Can not find ANDROID_NDK_ROOT, please set ANDROID_NDK_ROOT environment variable."
  exit 1
fi
CC32=$(find $ANDROID_NDK_ROOT | grep 'armv7a-linux-androideabi21-clang$')
CC64=$(find $ANDROID_NDK_ROOT | grep 'aarch64-linux-android21-clang$')
if [ "$CC32" == "" -o "$CC64" == "" ]; then
  echo "Can not find gcc compiler in '$ANDROID_NDK_ROOT'."
  exit 2
fi
# 下载gost源码
pushd "$(cd "$(dirname "$0")"; pwd)" >/dev/null 2>&1
rm -fr gost*
curl "https://github.com/ginuerzh/gost/archive/v$GOST_VERSION.tar.gz" -L -o gost.tar.gz
tar -zxvf gost.tar.gz
mv gost-$GOST_VERSION gost
# 编译gost执行程序
cd gost
echo "Compiling gost for android/arm..."
CC=$CC32 GOOS="android" GOARCH="arm" CGO_ENABLED="1" \
go build -ldflags "-s -w" -a -o ./gost32 ./cmd/gost
if [ $? -ne 0 ]; then
  echo "Compile gost for android/arm failed."
  exit 3
fi
echo "Compiling gost for android/arm64..."
CC=$CC64 GOOS="android" GOARCH="arm64" CGO_ENABLED="1" \
go build -ldflags "-s -w" -a -o ./gost64 ./cmd/gost
if [ $? -ne 0 ]; then
  echo "Compile gost for android/arm64 failed."
  exit 4
fi
# 拷贝gost执行程序
echo "Copying gost executables..."
cp -vf gost32 ../../LocalProxy/
cp -vf gost64 ../../LocalProxy/

popd >/dev/null 2>&1
echo "Build gost for android success."

