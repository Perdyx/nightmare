#!/bin/bash

set -e

echo "root:${ROOT_PASSWORD}" | chpasswd

/usr/sbin/sshd # Start SSH daemon in the background

hexstrike_server