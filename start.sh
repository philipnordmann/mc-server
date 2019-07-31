#!/usr/bin/env bash
echo "eula=true" > eula.txt
if [[ -f /opt/minecraft/etc/server.conf ]]; then
  for opt in $(cat /opt/minecraft/etc/server.conf); do
    JAVA_OPTS="$opt $JAVA_OPTS"
  done
fi

echo "JAVA_OPTS: $JAVA_OPTS"

java $JAVA_OPTS -jar ../bin/server.jar 