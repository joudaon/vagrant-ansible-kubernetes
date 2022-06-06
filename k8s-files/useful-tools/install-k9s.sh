#!/bin/bash

K9S_VERSION="v0.25.18"

echo "----> Installing k9s."

cd /tmp
wget https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_x86_64.tar.gz
tar -zxvf k9s_Linux_x86_64.tar.gz
cp k9s /usr/local/bin/k9s

rm -rf k9s_Linux_x86_64.tar.gz k9s LICENCE README.md
echo "k9s Version --> $(k9s version)"

echo "--> k9s successfully installed."