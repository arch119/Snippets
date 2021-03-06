PS1="[(\h) \u:\w]
-+ "
set -o vi

DEV_ROOT=~/dev

alias lrt="ls -lrt"
alias pss="ps aux | grep $USER | grep -v grep"
alias rm="rm -i"
alias mv="mv -i"
alias dev="cd ~/dev"
alias ws="python3 -m http.server"

export CLICOLOR='true'
export LSCOLORS="gxfxcxdxbxegedabagacad"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

#Locale
LC_CTYPE=en_US.UTF-8
alias gdiff='git difftool'
alias src-bashrc='. ~/.bashrc'
alias venv='virtualenv'
alias git_revert='git checkout HEAD'
alias cert-info='openssl x509 -noout -text -in'
alias cert-verify='openssl verify -CAfile' #needs 2 args - CAcert (or chain cert) and the cert to verify
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
alias fw="NODE_PATH=/usr/local/lib/node_modules/ node ~/dev/utils/fs_watch.js"

de(){
	docker exec -it $1 /bin/bash
}

del_branch()
{
	git branch -D $1 && git push -d origin $1
}

#fzf/ripgrep
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g '!{.git,node_modules}/*' 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bind -x '"\C-p": vim $(fzf);'


fno(){
	if [ $# -lt 1 ]; then
		echo "Usage: fno <pattern>"
		return 1
	fi
	local file=$(rg --hidden $1 | fzf | cut -f1 -d:)
	[ -z $file ] || vim $file
}