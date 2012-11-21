#! /bin/bash

function usage () {
   cat <<EOF
Usage: scriptname [-d folder] [-g git repo] [-b git branch] [-i remote ip] [-u user] [-h]
   -d   the folder you're going to install this
   -g   defines the git repo
   -b   defines the git branch
   -i   defines the remote ip
   -u   defines the user
   -h   displays basic help
EOF
}

if [ "$1" = "-h" ]
then
   usage
   exit 0
fi

while getopts d:g:b:i:u:h o
do  case "$o" in
    d)  directory="$OPTARG";;
    s)  paste=hpaste;;
    [?])    print >&2 "Usage: $0 [-s] [-d seplist] file ..."
        exit 1;;
    esac
done
shift $OPTIND-1

clear
echo -n "INSERT THE PROJECT NAME : "
read PROJECT
if [ "$PROJECT" = '' ]; then
  echo "you must provide a project name"
  exit 1
fi

rm -rf /tmp/Drushistrano
echo "  "
echo "  "
echo "---------------------------------------------"
echo "     Cloning script for the black magic "
echo "---------------------------------------------"
echo "  "
echo "  "

git clone https://github.com/carl0s/Drushistrano.git /tmp/Drushistrano
echo "  "
echo "  "
echo "---------------------------------------------"
echo "  SETTING UP THE ENVIRONMENT FOR CAPISTRANO "
echo "---------------------------------------------"
echo "  "
echo "  "



cd $2
echo -n "You're in "
echo -n `pwd`
echo -n " folder"
echo "  "
echo "  "

if [ "$3" != "" ]; then
    REMOTE_GIT=$PROJECT
else
    REMOTE_GIT=$3
fi

if [ "$4" != "" ]; then
    BRANCH="master"
else
    BRANCH=$4
fi

if [ "$5" != "" ]; then
    REMOTE_IP="cap.nois3lab.it"
else
    REMOTE_IP=$5
fi

if [ "$6" != "" ]; then
    USER="nois3lab"
else
    USER=$6
fi

if [ "$7" != "" ]; then
    DOMAIN=$PROJECT
else
    DOMAIN=$7
fi


if [ ! -d "includes" ]; then
    # Control will enter here if $DIRECTORY doesn't exist.
    clear
    echo ":("
    echo "You're not in a drupal installation"
    exit 1

else

    echo "  "
    echo "  "
    echo "---------------------------------------------"
    echo "  Preparing environment for cosy deployment  "
    echo "---------------------------------------------"
    echo "  "
    echo "  "

    cp /tmp/Drushistrano/Capfile .
    cp -R /tmp/Drushistrano/includes/deploy includes/
    sed -i -bak "s/#APPLICATION_NAME#/$PROJECT/g" includes/deploy/stages.rb
    sed -i -bak "s/#REMOTE_GIT_PATH#/$REMOTE_GIT/g" includes/deploy/stages.rb
    sed -i -bak "s/#BRANCH#/$BRANCH/g" includes/deploy/stages.rb
    sed -i -bak "s/#REMOTE_SERVER_IP#/$REMOTE_IP/g" includes/deploy/stages.rb
    sed -i -bak "s/#USER#/$USER/g" includes/deploy/stages.rb
    sed -i -bak "s/#DOMAIN#/$DOMAIN/g" includes/deploy/stages.rb
fi




if [ ! -d "sites" ]; then
    # Control will enter here if $DIRECTORY doesn't exist.
    clear
    echo ":("
    echo "You're not in a drupal installation"
    exit 1
else
    cp .htaccess htaccess
    cd sites
    echo "  "
    echo "  "
    echo "---------------------------------------------"
    echo "  Removing default folder from drupal "
    echo "---------------------------------------------"
    echo "  "
    echo "  "
    rm -rf default
    cp -R /tmp/Drushistrano/default-development .
    cp -R /tmp/Drushistrano/default-production .
fi



