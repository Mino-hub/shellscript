#!/bin/bash
set timeout 5
spawn ssh -p22 vagrant@centos66
expect "Permission denied"
echo "p"
