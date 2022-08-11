#!/bin/bash
#

source validators.sh

_install_py(){
  # args:
  # 1. Dict, ARGS

  ARGS=$1

  for key in ${!ARGS[@]}; do
    echo "${key} ${ARGS[$key]}"
  done

  sudo apt -y install libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev libtk8.6 libgdm-dev libdb4o-cil-dev libpcap-dev
  sudo apt -y install build-essential checkinstall
  sudo apt -y install libreadline-gplv2-dev tk-dev libc6-dev libbz2-dev
  sudo apt -y install openssl

  echo
  echo "# Start Python ${ARGS[ver]} Installation ----- #"
  echo "# 1. Install Python Package ----- #"
  wget -O /opt/Python-${ARGS[ver]}.tgz https://www.python.org/ftp/python/"${ARGS[ver]}"/Python-"${ARGS[ver]}".tgz
  tar -zxvf /opt/Python-${ARGS[ver]}.tgz -C /opt

  echo
  echo "# 2. Install Python 3.7.10 ----- #"
  cd /opt/Python-${ARGS[ver]}/
  eval sudo /opt/Python-${ARGS[ver]}/configure --prefix=${ARGS[python_dir]} --enable-optimizations --with-ssl
  make -C /opt/Python-${ARGS[ver]}  && make altinstall

  short_ver=`_extract_short_version_from_python_version ${ARGS[ver]}`
  ln -s "${ARGS[python_dir]}"/bin/python$short_ver /usr/bin/python"${ARGS[abbr]}"
  ln -s "${ARGS[python_dir]}"/bin/pip$short_ver /usr/bin/pip"${ARGS[abbr]}"

  echo
  echo "# 3. Equipped with Virtualenv ----- #"
  pip37 install virtualenv virtualenvwrapper
  ln -s "${ARGS[python_dir]}"/bin/virtualenv /usr/bin/virtualenv"${ARGS[abbr]}"

  echo
  echo "# 4. Clear Packages and Make Env ----- #"
  rm -rf /opt/Python-"${ARGS[ver]}".tgz
  rm -rf /opt/Python-"${ARGS[ver]}"

  echo
  echo "# Finish ----- #"
  echo "LIB:        ${ARGS[python_dir]}"
  echo "PIP:        pip$short_ver -> /usr/bin/pip${ARGS[abbr]}"
  echo "PYTHON:     pip$short_ver -> /usr/bin/python${ARGS[abbr]}"
  echo "VIRTUALENV: virtualenv${ARGS[abbr]} -> /usr/bin/virtualenv${ARGS[abbr]}"
}


_extract_abbr_from_python_version(){
  # args:
  # 1: string, python version

  # match regex and extract digit
  [[ $1 =~ ^([2-3]{1})[[:punct:]]([0-9]{1,2})[[:punct:]][0-9]{1,2}$ ]] && echo "${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
}


_extract_short_version_from_python_version(){
  # args:
  # 1: string, python version

  # match regex and extract digit
  [[ $1 =~ ^([2-3]{1})[[:punct:]]([0-9]{1,2})[[:punct:]][0-9]{1,2}$ ]] && echo "${BASH_REMATCH[1]}.${BASH_REMATCH[2]}"
}


install_python(){
  # args:
  # 1: Dict, ARGS

  ARGS=$1

  # validate named parameters
  check_download_params "$ARGS"

  # validate version abbreviation
  if [ -z ${ARGS[abbr]} ]; then
    ARGS[abbr]=`_extract_abbr_from_python_version ${ARGS[ver]}`
  fi

  # validate path
  if [ -z ${ARGS[python_dir]} ]; then
    ARGS[python_dir]="/usr/local/lib/python${ARGS[abbr]}"
    mkdir -p ${ARGS[python_dir]}
  fi

  # start installation
  _install_py $ARGS
}