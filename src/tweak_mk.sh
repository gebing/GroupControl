#!/bin/sh
# 获取脚本目录
PROJECT_HOME=$(cd "$(dirname "$0")"; pwd)
TWEAK_SRC=$(cd "$PROJECT_HOME/../../ExposedTweak/app/release/"; pwd)
TWEAK_DST=$(cd "$PROJECT_HOME/../ExposedTweak/"; pwd)

# 拷贝ExposedTweak.apk
cp -vf "$TWEAK_SRC"/ExposedTweak*.apk "$TWEAK_DST"/ExposedTweak.apk

if [ $? -ne 0 ]; then
  rm -f "$TWEAK_DST"
  echo Copy 'ExposedTweak.apk' failed!
  exit 1
fi

echo Update 'ExposedTweak.apk' success.
