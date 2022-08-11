#!/bin/bash
#

source validators.sh

new_venv(){
  # args:
  # 1: Dict ARGS

  ARGS=$1
  check_newenv_params "$ARGS"

  if [[ "${ARGS[abbr]}" =~ ^[0-9]{2,3}$ ]]; then
    ARGS[abbr]="/usr/bin/virtualenv${ARGS[abbr]}"
  fi

  echo "# ----- Start Envr Init ---- #"
  eval ${ARGS[abbr]} ${ARGS[venv]}

  echo "# ----- Start Configuring Envr ------ #"
  eval "${ARGS[venv]}/bin/pip -r ${ARGS[reqr]}}"

  echo "# ----- Finish ----- #"
  echo "SOURCE:        ${ARGS[abbr]}"
  echo "VENV:          ${ARGS[venv]}"
  echo "REQR:          ${ARGS[reqr]}"

  python_info=$(`${ARGS[venv]}/bin/python -v`)
  echo "PYTHON:        ${python_info}"
  echo "DIST-PKG:"
  eval "source ${ARGS[venv]}/bin/activate"
  eval "pip list"
}