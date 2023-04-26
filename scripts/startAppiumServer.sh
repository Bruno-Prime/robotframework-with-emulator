#!/bin/bash
set -ex
npm install -g appium
# npm install -g appium@next
# appium driver install xcuitest
# appium driver install espresso
# appium driver install flutter

appium -v
appium --relaxed-security --log results/appium.log &>/dev/null &