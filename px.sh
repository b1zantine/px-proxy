#!/bin/sh

_DOMAIN="proxy.ssn.net"
_PORT=8080
_IGNORE_PROXY="'*.ssn.net'"
_ENV_FILE_PATH="/etc/environment"
_APT_FILE_PATH="/etc/apt/apt.conf"

_MODE_MANUAL="manual"
_MODE_NONE="none"

_APT_CONF_DATA="Acquire::http::proxy \"http://$_DOMAIN:$_PORT/\";\nAcquire::https::proxy \"https://$_DOMAIN:$_PORT/\";\nAcquire::ftp::proxy \"ftp://$_DOMAIN:$_PORT/\";\nAcquire::socks::proxy \"socks://$_DOMAIN:$_PORT/\";"

_ENV_CONF_DATA="http_proxy=\"http://$_DOMAIN:$_PORT/\"\nhttps_proxy=\"https://$_DOMAIN:$_PORT/\"\nftp_proxy=\"ftp://$_DOMAIN:$_PORT/\"\nsocks_proxy=\"socks://$_DOMAIN:$_PORT/\""

######  APT proxy settings
unset_apt_proxy () {
	awk '!/^Acquire::\w+::proxy/' $_APT_FILE_PATH > temp && chmod 0644 temp && sudo mv -f temp $_APT_FILE_PATH
}

set_apt_proxy () {
	unset_apt_proxy
	echo $_APT_CONF_DATA | cat >> $_APT_FILE_PATH
}

######  Environment proxy settings
unset_env_proxy () {
	awk '!/^\w+_proxy/' $_ENV_FILE_PATH > temp && chmod 0644 temp && sudo mv -f temp $_ENV_FILE_PATH 
}

set_env_proxy () {
	unset_env_proxy
	echo $_ENV_CONF_DATA | cat >> $_ENV_FILE_PATH
}

	
######  GNOME3 proxy settings
set_gnome_proxy () {
	
	gsettings set org.gnome.system.proxy mode $_MODE_MANUAL 
	gsettings set org.gnome.system.proxy.http host $_DOMAIN
	gsettings set org.gnome.system.proxy.http port $_PORT
	gsettings set org.gnome.system.proxy.https host $_DOMAIN
	gsettings set org.gnome.system.proxy.https port $_PORT
	gsettings set org.gnome.system.proxy.ftp host $_DOMAIN
	gsettings set org.gnome.system.proxy.ftp port $_PORT
	gsettings set org.gnome.system.proxy.socks host $_DOMAIN
	gsettings set org.gnome.system.proxy.socks port $_PORT
	gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12',  $_IGNORE_PROXY ]"

}

unset_gnome_proxy () {
	gsettings set org.gnome.system.proxy mode $_MODE_NONE
}

###### Git proxy settings ######
set_git_proxy () {
	git config --global http.proxy $_DOMAIN:$_PORT
	git config --global https.proxy $_DOMAIN:$_PORT
	echo "\t** Git proxy  -  OK"
}

unset_git_proxy () {
	git config --global --unset http.proxy
	git config --global --unset https.proxy
	echo "\t** Git proxy  -  REMOVED"
}

###### All proxies ######
set_proxy () {
	set_gnome_proxy
	set_apt_proxy
	set_env_proxy
	echo "\t** System proxy  -  OK"
}

unset_proxy () {
	unset_gnome_proxy
	unset_apt_proxy
	unset_env_proxy
	echo "\t** System proxy  -  REMOVED"
}

proxy_stat () {
	
	echo "STATUS:\n-----------\n***** System proxy ******\n"
	env | grep -i "_proxy"
	echo "\n***** Git proxy ******\n[http]"
	git config --global --get http.proxy
	echo "[https]"
	git config --global --get https.proxy

}

case $1 in  
	'stat')
		proxy_stat
	;;

	'0')
		unset_proxy
	;;

	'1')
		set_proxy
	;;

	'0g')
		unset_git_proxy
	;;

	'1g')
		set_git_proxy
	;;

	*)
		echo "\nUsage :\n---------------\npx 1\t:: Setting System proxy\npx 0\t:: Unsetting System proxy\n\npx 1g\t:: Setting Git proxy\npx 0g\t:: Unsetting Git proxy\n\npx stat\t:: Checking proxy status\n"
 		exit 1
	;;
esac

exit 0
