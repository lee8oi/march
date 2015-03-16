#!/bin/bash
repo_name="localrepo"
master_url="https://raw.githubusercontent.com/lee8oi/march/master/"
packages_i686=""
packages_x86_64=""
packages_both="\
base
base-devel
xorg-server
xorg-server-utils
alsa-lib
alsa-plugins
alsa-tools
alsa-utils
plasma
phonon-qt5-vlc
vlc
libx264
sddm
tmux
vim
elinks
vim-syntastic
zsh
zsh-completions
zsh-syntax-highlighting
"
clean() {
	rm -rf *_db *~
	return 0
}

create() {
	if [ $1 ]; then
		mkdir $1
		if [ -d $1 ]; then
			full_path=`pwd`/$1
			repo_conf=${full_path}/${repo_name}.conf
			db_dir=${full_path}/${1}_db
			conf_file=${full_path}/pacman.${1}.conf
			mkdir $db_dir
			wget -P $full_path ${master_url}/pacman.${1}.conf
			if [ ! -f  $repo_conf ]; then
				touch $repo_conf
				#echo "db_dir=${full_path}/${1}_db" >> $repo_conf
				echo "pac_opts=\"--noconfirm --config $conf_file --dbpath $db_dir --cachedir $full_path\"" >> $repo_conf
			fi
		fi
	fi
}

delete() {
	rm -rf *_db i686 x86_64
}

fetch () {
	if [ $1 ];  then
		if [ -f $1/${repo_name}.conf ]; then
			pacman -Syu
			pack_name=$"packages_$1"
			eval pkgs="\$$pack_name"
			source $1/${repo_name}.conf

			pacman $pac_opts -Syy
			pacman $pac_opts -Sw $pkgs $packages_both
		else
			echo "Invalid repo: $1"
		fi
	else
		echo "Example usage: $0 fetch i686"
	fi
}

pkg_get() {
	pacman $pac_opts -Sw $@
}

update() {
	if [ $1 ] && [ -d $1 ]; then
		repo_update $1
		exit 0
	else
		echo "Example usage: $0 update ./i686"
		exit 1
	fi
}

repo_update() {
	if [ -d $1 ]; then
		repo-add $1/${repo_name}.db.tar.gz $1/*.pkg.tar.xz
	else
		echo "Package directory not found: \"$1\""
		exit 1
	fi
}

case "$1" in
clean)	clean
	exit 0
	;;
create) create $2
	;;
delete) delete
	;;
update)	fetch $2
	update $2
	;;
fetch)	fetch $2
	;;
esac
