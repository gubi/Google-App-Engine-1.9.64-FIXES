#!/bin/bash
# Shared script for appcfg.sh, dev_appserver.sh, and endpoints.sh.
# Checks that the java command reports at least the minimum required version
# before running it. The arguments to this script are, first, the name of
# the script we are doing this for (for example appcfg.sh), then all of the
# arguments to be passed to the java binary.

readonly SCRIPT_NAME="$1"
shift

VERSION=$(java -version 2>&1 | sed -n '1s/.*version \"\([0-9]\+\).*\".*/\1/p');
if [[ $VERSION == 1 ]]
    then
    VERSION=$(java -version 2>&1 | sed -n '1s/.*version \"[0-9]\+\.\([0-9]\+\).*\".*/\1/p');
fi

case "${VERSION}" in
[1-6])
  cat >&2 <<EOF
${SCRIPT_NAME} requires at least Java 7 (also known as 1.7).

The java executable at $(type -p java) reports:
$(java -version 2>&1)

You can download the latest JDK from:
  http://www.oracle.com/technetwork/java/javase/downloads/index.html

EOF
  exit 1;;
[7-9])
  ;;
1[0-9])
  ;;
*)
  echo "Warning: unable to determine Java version" >&2;;
esac

exec java "$@"
# exec java --add-modules=java.xml.bind,java.activation "$@"
