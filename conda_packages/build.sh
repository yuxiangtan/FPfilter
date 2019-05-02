#!/bin/env bash

mkdir -p $PREFIX/bin
mkdir -p $PREFIX/lib/FPfilter

cat <<EOF >$PREFIX/bin/FPfilter
#!/bin/env bash
SCRIPT_DIR=\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )
FPF_DIR=\$( cd \$SCRIPT_DIR/../lib/FPfilter && pwd )
sh \$FPfilter/FPfilter.sh \$@
EOF
chmod +x $PREFIX/bin/FPfilter
cp  ../../FPfilter-v1/* $PREFIX/lib/FPfilter/
