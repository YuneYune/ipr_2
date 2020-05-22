#!/usr/bin/env bash
TARGET_ENV=$1
gem install rainbow -v '2.2.2'
bundler install
export LANG=C.UTF-8 && locale
cucumber --format pretty --format json --out report.json -f rerun --out rerun.txt
exit 0