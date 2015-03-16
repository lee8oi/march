lists_download() {
	if [ -d $1 ]; then
		for i in ${@:2}; do
			wget -P $1 ${master_url}/package_lists/$i.list
			if [ $? -ne 0 ];then
				exit 1
			fi
		done
	else
		echo "Invalid repo '$1'"
	fi
}

lists_remove() {
	if [ -d $1/mod_listss ]; then
		for i in ${@:2}; do
			rm $1/mod_listss/$i.list
		done
	fi
}

mod_lists() {
	help () {
		echo "Usage: $0 list <add|remove> <repo> <list(s)> "
		echo "Example: $0 list add ~/localrepo/i686 base"
	}
	if [ $# -ge 3 ]; then 
		case "$1" in
			add)
				lists_download $2/package_lists ${@:3}
				;;
			remove)
				lists_remove ${@:2}
				;;
			*)
				help
				;;
		esac
	else
		help
	fi
}
