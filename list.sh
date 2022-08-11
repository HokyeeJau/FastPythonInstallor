#!/bin/bash
#

list(){
  echo "[PIP]"
  ls /usr/bin | grep '^pip[^a-zA-Z-]*$'
  echo

  echo "[PYTHON]"
  ls /usr/bin | grep '^python[^a-zA-Z-]*$'
  echo

  echo "[VIRTUALENV]"
  ls /usr/bin | grep '^virtualenv[^a-zA-Z-]*$'
  echo
}