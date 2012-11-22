#! /bin/bash

function usage () {
   cat <<EOF
Usage: scriptname [-d folder] [-p project] [-g git repo] [-b git branch] [-i remote ip] [-u user] [-h]
   -d   the folder you're going to install this
   -p   project name
   -g   defines the git repo
   -b   defines the git branch
   -i   defines the remote ip
   -u   defines the user
   -s   defines the domain
   -t   initializing git repo
   -h   displays basic help
EOF
}

if [ "$1" = "-h" ]
then
   usage
   exit 0
fi

while getopts p:d:g:b:i:u:h:s:t o
do  case "$o" in
    p)  APPLICATION="$OPTARG";;
    d)  PROJECT="$OPTARG";;
    g)  REMOTE_GIT="$OPTARG";;
    b)  BRANCH="$OPTARG";;
    i)  REMOTE_IP="$OPTARG";;
    u)  USER="$OPTARG";;
    s)  DOMAIN="$OPTARG";;
    t)  GIT_INIT="$OPTARG";;

    esac
done
shift $OPTIND-1


if [ REMOTE_GIT = "" ]; then
    REMOTE_GIT=$APPLICATION
fi

if [ BRANCH = "" ]; then
    BRANCH="master"
fi

if [ REMOTE_IP = "" ]; then
    REMOTE_IP="cap.nois3lab.it"
fi

if [ USER = "" ]; then
    USER="nois3lab"
fi

if [ DOMAIN != "" ]; then
    DOMAIN=$APPLICATION
fi

clear

if [ ! -d $PROJECT"/sites" ]; then
    echo "$PROJECT/sites"
    echo "This is for Drupal projects, please provide a 'sites' folder"
    exit 1
else

    rm -rf /tmp/Drushistrano

    echo "  "
    echo "  "
    echo "---------------------------------------------"
    echo "   Checking if this is already drucapified   "
    echo "---------------------------------------------"
    echo "  "
    echo "  "

    if [ -d "includes/deploy" ]; then
        # Control will enter here if $DIRECTORY doesn't exist.
        clear
        echo "Cheers! the project is already drucapified!"
        exit 1

    else
        echo "[ok!]"
        echo "  "
        echo "  "
        echo "---------------------------------------------"
        echo "     Cloning script for the black magic "
        echo "---------------------------------------------"
        echo "  "
        echo "  "

        git clone https://github.com/carl0s/Drushistrano.git /tmp/Drushistrano
        echo "[ok!]"
        echo "  "
        echo "  "
        echo "---------------------------------------------"
        echo "  SETTING UP THE ENVIRONMENT FOR CAPISTRANO "
        echo "---------------------------------------------"
        echo "  "
        echo "  "

        cd $PROJECT
        rm -rf .git
        rm -rf .gitignore

        echo "[ok!]"
        echo -n "You're in "
        echo -n `pwd`
        echo -n " folder"
        echo "  "
        echo "  "



        echo "  "
        echo "  "
        echo "---------------------------------------------"
        echo "  Preparing environment for cosy deployment  "
        echo "---------------------------------------------"
        echo "  "
        echo "  "

        cp /tmp/Drushistrano/Capfile .
        cp -R /tmp/Drushistrano/includes/deploy includes/
        sed -i -bak "s/#APPLICATION_NAME#/$APPLICATION/g" includes/deploy/stages.rb
        sed -i -bak "s/#REMOTE_GIT_PATH#/$REMOTE_GIT/g" includes/deploy/stages.rb
        sed -i -bak "s/#BRANCH#/$BRANCH/g" includes/deploy/stages.rb
        sed -i -bak "s/#REMOTE_SERVER_IP#/$REMOTE_IP/g" includes/deploy/stages.rb
        sed -i -bak "s/#USER#/$USER/g" includes/deploy/stages.rb
        sed -i -bak "s/#DOMAIN#/$DOMAIN/g" includes/deploy/stages.rb

        cp .htaccess htaccess
        cd $PROJECT/sites
        echo "[ok!]"
        echo "  "
        echo "  "
        echo "---------------------------------------------"
        echo "  Removing old default folder from drupal "
        echo "---------------------------------------------"
        echo "  "
        echo "  "
        rm -rf default
        cp -R /tmp/Drushistrano/default-development .
        cp -R /tmp/Drushistrano/default-production .

        echo "  "
        echo "executed "
        echo -n cp -R /tmp/Drushistrano/default-production .
        echo "  "
        echo "executed "
        echo -n cp -R /tmp/Drushistrano/default-development .

        echo "                      [ok!]"
        echo "  "
        echo "  "
        echo "---------------------------------------------"
        echo "         Creating the right domain "
        echo "---------------------------------------------"
        echo "  "
        echo "  "

        cp -R /tmp/Drushistrano/default $APPLICATION
        mkdir $APPLICATION/files

        echo "  "
        echo "executed "
        echo -n cp -R /tmp/Drushistrano/default $APPLICATION
        echo "                     [ok!]"



        echo "  "
        echo "  "
        echo "---------------------------------------------"
        echo "         Symlinking for the win "
        echo "---------------------------------------------"
        echo "  "
        echo "  "

        ln -s $APPLICATION default

        echo "  "
        echo "executed "
        echo -n ln -s $APPLICATION default
        echo "                  [ok!]"

        if [ ! GIT_INIT = "" ]; then
            echo "  "
            echo "  "
            echo "---------------------------------------------"
            echo "         Initialized Git environment "
            echo "---------------------------------------------"
            echo "  "
            echo "  "

            git init $PROJECT/.
            cp /tmp/Drushistrano/gitignore .gitignore
            git add .
            git commit -am "Initial commit"
            git remote add origin git@git.nois3lab.it:$REMOTE_GIT.git
            echo "[ok!]"
        else
            git add -f $PROJECT/sites/$APPLICATION/settings.development.php
            git add -f $PROJECT/sites/$APPLICATION/settings.production.php
            git commit -am "Adding settings to repository"

        fi
    fi

fi











