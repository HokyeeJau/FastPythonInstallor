#!/bin/bash
#

# validate full python version
_check_python_version(){
  # args:
  # 1: string, python full version
	if [[ "$1" =~ ^[2-3]{1}[[:punct:]][0-9]{1,2}[[:punct:]][0-9]{1,2}$ ]]; then
	  return 1
	else
	  return 0
	fi
}


# 2~3 digits or empty string
_check_python_abbr(){
  # args:
  # 1: string, python version abbreviation
	if [[ "$1" =~ ^[0-9]{2,3}$ ]]; then
	  return 1
	elif [[ -z "$1" ]]; then
	  return 1
	else
	  return 0
	fi
}

# check python or pip existence
_check_virtualenv_existence(){
  # args:
  # 1: string, python version abbreviation or path to pip

  ver_=$1

  if [[ "$ver_" =~ ^[0-9]{2,3}$ ]]; then
    if [ ! -x /usr/bin/pip${ver_} ]; then
      echo "/usr/bin/pip${ver_} does not exist!"
      exit 1
    fi
  elif [ ! -x $ver_ ]; then
    echo "${ver_} does not exist!"
    exit 1
  fi
}


# check python path,
# only non-empty and unexisted path will be newed,
# if empty, then it uses default path.
_check_python_path(){
  # args:
  # 1: string, python path directory
  if [ ! -x $1 ] && [ -n "$1" ]; then
    mkdir -p $1
  fi
}


# check directory of venv,
# ensure its existence
_check_venv_directory(){
  # args:
  # 1: string, venv dir
  venv_path=$1
  venv_dir=`dirname ${venv_path}`

  if [ ! -d $venv_dir ]; then
    mkdir -p $venv_dir
  fi
}


# check requirements.txt for new env,
# ensure its existence
_check_venv_reqr(){
  # args:
  # 1: string, requirement file path
  if [ ! -f $1 ]; then
    echo "${1} does not exist"
    exit 1
  fi
}


# check parameters for download
check_download_params(){
  # args:
  # 1: Dict, ARGS

  ARGS=$1

  _check_python_version ${ARGS[ver]}
  RES=$?
  if [ $RES -eq 0 ]; then
    echo "python version should be fully given, e.g, 3.7.10"
    exit 1
  fi

  _check_python_abbr ${ARGS[abbr]}
  RES=$?
  if [ $RES -eq 0 ]; then
    echo "python version abbreviation should be more than 1 digit, e.g., 37"
    exit 1
  fi

  _check_python_path ${ARGS[python_dir]}
}


# check parameters for new environment
check_newenv_params(){
  # args:
  # 1: Dict, ARGS

  ARGS=$1

  _check_virtualenv_existence ${ARGS[abbr]}
  _check_venv_directory ${ARGS[venv]}
  _check_venv_reqr ${ARGS[reqr]}
}

