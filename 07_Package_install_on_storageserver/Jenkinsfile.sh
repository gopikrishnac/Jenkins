#!/bin/bash

set -e

echo "Installing package: $PACKAGE"

sshpass -p 'STORAGE_PASSWORD' ssh \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    natasha@ststor01 \
    "sudo yum install -y '$PACKAGE'"

echo "Package installation completed successfully."