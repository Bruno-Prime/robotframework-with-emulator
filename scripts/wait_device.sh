#!/bin/bash

waitForDevice() {
  local emulatorBootTimeout=$1
  local booted=false
  local attempts=0
  local retryInterval=2
  local maxAttempts=$((emulatorBootTimeout / 2))

  while [ "$booted" = false ]; do
    result=$(adb shell getprop sys.boot_completed)
    if [ "$result" = "1" ]; then
      echo "Emulator booted."
      booted=true
      break
    fi

    if [ "$attempts" -lt "$maxAttempts" ]; then
      sleep $retryInterval
    else
      echo "Timeout waiting for emulator to boot."
      exit 1
    fi

    attempts=$((attempts + 1))
  done
}

# Chamar a função waitForDevice com o tempo limite em segundos
if [ $# -eq 0 ]; then
  waitForDevice 60
else
  waitForDevice "$1"
fi
