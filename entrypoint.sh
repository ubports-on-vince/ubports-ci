#!/usr/bin/env bash
set -e
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts

## Running passed command
if [[ "$1" ]]; then
        eval "$@"
else
  eval "/bin/bash"
fi
