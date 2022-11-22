#!/bin/bash

# isInstalled=$(dpkg-query -l sudo)

# if [[ $isInstalled ]]; then
# # if dpkg-query -l xinit; then
#     echo -e "sudo is allready installed"
# else
#     echo -e "sudo is not installed"
# fi

# echo -e "\n\r$isInstalled"

isInstalled() {
  target=$1
  isInstalledResult=$(dpkg-query -l $target)

  if [[ $isInstalledResult ]]; then
  # if dpkg-query -l xinit; then
    echo -e "$target is allready installed"
    return 0
  else
    echo -e "$target is not installed"
    return 1
  fi
}

# lVar="sdsd"
# if [ -z "${lVar}" ]; then
#     echo "lVar is unset or set to the empty string"
# fi
# if [ -z "${lVar+set}" ]; then
#     echo "lVar is unset"
# fi
# if [ -z "${lVar-unset}" ]; then
#     echo "lVar is set to the empty string"
# fi
# if [ -n "${lVar}" ]; then
#     echo "lVar is set to a non-empty string"
# fi
# if [ -n "${lVar+set}" ]; then
#     echo "lVar is set, possibly to the empty string"
# fi
# if [ -n "${lVar-unset}" ]; then
#     echo "lVar is either unset or set to a non-empty string"
# fi


# isNotInstalled() {
#     echo -e "verifing $1"
#     return 0
# }
app="xinita"
if isInstalled $app; then
  echo -e "sudo is installed"
else
  # rPassword="123qweasd"
  if [ -z "${rPassword}" ]; then
      echo -e "enter root password"
  else
      echo -e "has root password!"
  fi
  echo -e "installing sudo..."
  echo $rPassword | su -c "apt show $app"
fi 

