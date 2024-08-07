#
# .cshrc
# $Id: .cshrc,v 1.18 2024/07/29 13:42:07 suhara Exp suhara $
#

stty erase "^?" intr "^C" -ixon
#stty erase "^H" intr "^C" -ixon
umask 000

########
# Homebrew
########
setenv HOMEBREW_PREFIX /opt/homebrew
setenv HOMEBREW_CELLAR /opt/homebrew/Cellar
setenv HOMEBREW_REPOSITORY /opt/homebrew
setenv MANPATH /opt/homebrew/share/man:/opt/X11/share/man:/usr/share/man
setenv INFOPATH /opt/homebrew/share/info:/opt/X11/share/info:/usr/share/info

########
# Cargo
########
setenv CARGO_HOME $HOME/.cargo

set path = ( \
	$HOME/.cargo/bin \
	$HOME/.nodebrew/current/bin \
	$HOME/bin \
	/usr/local/{bin,sbin} \
	/opt/homebrew/{bin,sbin} \
	/opt/X11/bin/ \
	/usr/bin/X11 \
	/usr/{bin,sbin,games} \
	/{bin,sbin} \
)

########
# pkg_add -r emacs
########
#setenv PACKAGEROOT ftp://ftp.jp.freebsd.org/
#setenv PACKAGESITE ftp://ftp.jp.freebsd.org/pub/FreeBSD/ports/amd64/packages-8.1-release/Latest/
#setenv FTP_PASSIVE_MODE yes
#setenv HTTP_PROXY 192.168.6.8:1088    # for only MASC

if ($term == dumb) then
    unalias cd
else
    alias cd   'cd \!*; printf "\033]0;$cwd\007"'
endif    
alias grep grep -i
alias l    ls -F -1
alias ls   ls -F
alias ll   ls -F -l
alias dir  ls -F -lA
alias grep grep -i
alias rm   rm -i
alias jobs jobs -l
alias clean "/bin/rm -i err* del* ika* tako* *~ .*~ #* *.dvi *.aux *.eps *.bak"
alias more less -I -X                        # 画面クリアしない。
alias e    "(emacsclient --no-wait --alternate-editor=emacs \!* &)"

#########
# Wolfram 
#########
# 以下は一回実行すればよい。
#wolframscript -configre WOLFRAMSCRIPT_KERNELPATH "/Applications/Wolfram Engine.app/Contents/Resources/Wolfram Player.app/Contents/MacOS/WolframKernel"
#setenv WOLFRAMSCRIPT_KERNELPATH "/Applications/Wolfram Engine.app/Contents/Resources/Wolfram Player.app/Contents/MacOS/WolframKernel"

#########
# opam
#########
if ( -f /Users/suhara/.opam/opam-init/init.csh ) source /Users/suhara/.opam/opam-init/init.csh >& /dev/null

#########
# Coq
#########
alias coqdoc  coqdoc --utf8

##alias mc1  'opam switch 4.13.1 > /dev/null; eval `opam env`' 
##alias mc2  'opam switch 4.14.1 > /dev/null; eval `opam env`' 
##alias mc   'opam switch; coqc -v'
###alias mc   grep "switch:" ~/.opam/config
    
#########
# GitHub
#########
alias git_init "git add \!* ; git commit -m 'first commit'"
alias git_commit   git commit
alias git_push     git push -u origin master
alias git_log      git log --follow
alias git_key "eval `ssh-agent`; ssh-add"


#########
# cshell
#########
set notify

setenv PAGER "\less -I -X"                  # 画面クリアしない。
setenv DIFF_OPTIONS "-W160 -t"
setenv BLOCKSIZE 1k
setenv PRINTER ps
#setenv EDITOR vi
setenv EDITOR emacsclient
setenv PERL_BADLANG 0

set filec
set history = 1000
set ignoreeof
set mch = `hostname -s`
set prompt = "$mch{\!}% "

#########
# CABAL
#########
set path = (~/.cabal/bin $path)

########
# idris
########
setenv NO_COLOR

### END OF FILE
