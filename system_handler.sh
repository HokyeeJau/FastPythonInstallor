#!/bin/bash
#

source install.sh
source list.sh
source new_env.sh

# ip reg : ^((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.){3}(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$


usage(){
  echo 'AMP System Handler'
  echo
  echo "Usage: "
  echo "./system_handler.sh [COMMAND]"
  echo "./system_handler.sh --help"
  echo "Commands:"

  echo "[Common]"
  echo ":: common argument, required either \`-h\` or \`-a\`."
  echo "   -h,     --help              -- Help information"
  echo "   -a,     --action            -- Action keywords including install, list, new_env"
  echo

  echo "[List]"
  echo ":: no argument required"
  echo ":: list existed soft links to different python versions."
  echo

  echo "[Install]"
  echo ":: detailed arguments, required \`-v\`, \`-abbr\` and \`-dir\` can be specified or using default values."
  echo "   -v,     --version           -- Version of Python, default=3.7.10"
  echo "   -abbr,  --abbreviation      -- Abbreviation of Python version, default=37"
  echo "   -dir,   -- python_dir       -- Python Root Directory, default=/usr/local/lib/python\${abbr}"
  echo

  echo "[New Env]"
  echo ":: detailed arguments, required \`-abbr\`, \`-venv\` and \`-reqr\` can be specified or using default values"
  echo "   -abbr,  --abbreviation      -- abbreviation of python version, it should be already installed in /usr/bin or a virtualenv path"
  echo "   -venv,  --virtualvenv       -- path of virtual environment, default=/opt/venv"
  echo "   -reqr,  --requirements      -- path of requirements file for the venv, default=/opt/requirements.txt"
  echo
}


# parse the optional arguments,
# if option does not exist or extra arguments are given,
# just shift away.
declare -A ARGS
ARGS=()

ARGS[ver]="3.7.10"
ARGS[abbr]=""
ARGS[python_dir]=""
ARGS[action]="download"
ARGS[venv]="/opt/venv"
ARGS[reqr]="/opt/requirements.txt"

# if arguments are not given,
# exit program
if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

# parse the optional arguments,
# if option does not exist or extra arguments are given,
# just shift away.
while [[ $# -gt 0 ]]; do
  case $1 in
      -v|--version)
        ver="$2"
        ARGS[ver]=$ver
        echo "Version: $ver";
        shift 2
        ;;
      -abbr|--abbreviation)
        abbr="$2"
        ARGS[abbr]=$abbr
        echo "Abbr: $abbr"
        shift 2
        ;;
      -dir|--python_dir)
        python_dir="$2"
        ARGS[python_dir]=$python_dir
        echo "Python Dir: $python_dir"
        shift 2
        ;;
      -a|--action)
        action="$2"
        ARGS[action]=$action
        echo "Action: $action"
        shift 2
        ;;
      -venv|--virtualenv)
        venv="$2"
        ARGS[venv]=$venv
        shift 2
        ;;
      -reqr|--requirements)
        reqr="$2"
        ARGS[reqr]=$reqr
        shift 2
        ;;
      -h|--help)
        usage
        exit 1
        ;;
      -*|--*)
        echo "Unknown option $1"
        shift 2
        ;;
      -*)
        echo "Unknown argument $1"
        shift
        ;;
    esac
done

set -- "${ARGS[@]}"


case "${ARGS[action]}" in
  install)
    install_python "$ARGS"
    ;;
  new_env)
    new_venv "$ARGS"
    ;;
  list)
    list
    ;;
esac





