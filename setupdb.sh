#! /bin/bash

function usage () {
   cat <<EOF
Usage: scriptname [-d folder] [-p project] [-g git repo] [-b git branch] [-i remote ip] [-u user] [-h]
   -e  what kind of environment to set up
   -d  database name
   -u   defines the user
   -p   defines the password
   -t   website path
   -h   displays basic help
EOF
}

if [ "$1" = "-h" ]
then
   usage
   exit 0
fi

while getopts e:d:u:p:t: o
do  case "$o" in
    e)  ENVIRONMENT="$OPTARG"
		;;
	d)	DBNAME="$OPTARG"
		;;
	u)	DBUSER="$OPTARG"
		;;
	p)	DBPWD="$OPTARG"
		;;
	t)	WEBPATH="$OPTARG"
		;;
    \?) echo "Invalid option: -$OPTARG" >&2
        usage
        exit 1
    esac
done

if [ "$ENVIRONMENT" = "" ]; then
    echo "give me an environment choice"
    exit 0
fi

cd $WEBPATH/sites/default/
case "$ENVIRONMENT" in
	local)  DBUSER="root"
			DBPWD="root"
			sed -i -bak "s/#DATABASE#/$DBNAME/g" settings.php
			sed -i -bak "s/#DB_USERNAME#/$DBUSER/g" settings.php
			sed -i -bak "s/#DB_PWD#/$DBPWD/g" settings.php
			;;
	dev)	sed -i -bak "s/#DATABASE#/$DBNAME/g" settings.development.php
			sed -i -bak "s/#DB_USERNAME#/$DBUSER/g" settings.development.php
			sed -i -bak "s/#DB_PWD#/$DBPWD/g" settings.development.php
			;;
	prod)	sed -i -bak "s/#DATABASE#/$DBNAME/g" settings.production.php
			sed -i -bak "s/#DB_USERNAME#/$DBUSER/g" settings.production.php
			sed -i -bak "s/#DB_PWD#/$DBPWD/g" settings.production.php
			;;


	\?) echo "Invalid environment" >&2
	    exit 1;;
esac
