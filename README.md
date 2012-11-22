#Drucapify

Drucapify is a very ugly script that lets you kickstart a Drupal project with Drushistrano.

##Usage for drucapify
if you want to use to drucapify you may need to copy drucapify.sh into your /usr/local/bin/ folder or executing into the directory itself.

Usage: [./]drucapify [-d folder] [-g git repo] [-b git branch] [-i remote ip] [-u user] [-h]
* -p   project name
* -d   the folder you're going to install this
* -g   defines the git repo
* -b   defines the git branch
* -i   defines the remote ip
* -u   defines the user
* -s   defines the domain
* -t	 initializing git repository
* -h   displays basic help

##Usage for setupdb

if you want to setup your DBs for different environments
Usage: [./]setupdb.sh -e environment [-d db name] [-u db user] [-p db password] [-t settings.php path]  [-h]
* -e   environment type (local, dev, prod)
* -d   database name
* -u   db user
* -p   db password
* -t	 website path
* -h   displays basic help



