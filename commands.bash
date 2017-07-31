#!/usr/bin/env bash

# ===========
# ===========

# ===========
# where the ambientum cache will live
A_BASE=$HOME/.cache/ambientum

# ===========
# define specific cache directories
A_CONFIG=$A_BASE/.config
A_CACHE=$A_BASE/.cache
A_LOCAL=$A_BASE/.local
A_SSH=$HOME/.ssh
A_COMPOSER=$A_BASE/.composer

# ===========
# create directories
mkdir -p $A_CONFIG
mkdir -p $A_CACHE
mkdir -p $A_LOCAL
mkdir -p $A_COMPOSER

###########################################
#### DO NOT EDIT BELOW THIS LINE UNLESS   #
#### YOU KNOW WHAT YOU'RE DOING           #
###########################################

# ===========
# reset permissions
chown -R $(id -u):$(id -g) $A_BASE

# ===========
# home directory
A_USER_HOME=/home/ambientum

# ===========
# alias for NPM and other node commands

# ===========
# NODE ENV

function n() {

  docker run -it --rm -v $(pwd):/var/www/app -v $A_CONFIG:$A_USER_HOME/.config -v $A_CACHE:$A_USER_HOME/.cache -v $A_LOCAL:$A_USER_HOME/.local -v $A_SSH:$A_USER_HOME/.ssh ambientum/node:7 "$@"

}

alias n=n

# ===========
# PHP ENV

function p() {

  # ===========
  # [ ] need refactoring

  # ===========
  # set delimiter to split commands

  get="$@"
  delimiter=",,"

  # ===========
  # regex with sed

  regex="[^$delimiter]*\($delimiter.*\)"
  main=$(echo "${get}" | sed "s/$regex/\1/")

  # ===========

  # notes:
  #
  # ${#var} - return the lenght. example: 12
  # (-a) - is boolean operator AND
  # | xargs - remove whitespaces
  # eval - run string as the command

  if [ ${#main} -lt ${#get} -a ${#main} -gt 0 ]; then

    main=$(echo "${main}" | cut -c $(( ${#delimiter} + 1 ))- | xargs)
    itens=$(echo "${get}" | sed "s/$main//" | xargs | rev | cut -c $(( ${#delimiter} + 1 ))- | rev | xargs)

    # ===========
    # debug
    #
    # echo $main
    # echo $itens

    docker run -it --rm `eval echo $itens` -v $(pwd):/var/www/app -v $A_COMPOSER:$A_USER_HOME/.composer -v $A_CONFIG:$A_USER_HOME/.config -v $A_CACHE:$A_USER_HOME/.cache -v $A_LOCAL:$A_USER_HOME/.local -v $A_SSH:$A_USER_HOME/.ssh ambientum/php:7.1 `eval echo $main`

  else

    # ===========
    # original script with ports configuration

    docker run -it --rm -p 8001:8000 -v $(pwd):/var/www/app -v $A_COMPOSER:$A_USER_HOME/.composer -v $A_CONFIG:$A_USER_HOME/.config -v $A_CACHE:$A_USER_HOME/.cache -v $A_LOCAL:$A_USER_HOME/.local -v $A_SSH:$A_USER_HOME/.ssh ambientum/php:7.1 "$@"

  fi

}

alias p=p

# ===========
# ===========