#
# .cshrc
# $Id: .cshrc,v 1.10 2019/11/27 14:34:52 suhara Exp $
#

setenv LANG ja_JP.UTF-8

########
# pkg_add -r emacs
########
setenv PACKAGEROOT ftp://ftp.jp.freebsd.org/
#setenv PACKAGESITE ftp://ftp.jp.freebsd.org/pub/FreeBSD/ports/amd64/packages-8.1-release/Latest/
setenv FTP_PASSIVE_MODE yes
#setenv HTTP_PROXY 192.168.6.8:1088    # for only MASC

alias grep grep -i
alias l    ls -F -1
alias ls   ls -F
alias ll   ls -F -l
alias dir  ls -F -lA
alias grep grep -i
alias rm   rm -i
alias jobs jobs -l
alias clean "/bin/rm -i err del* ika* tako* *~ .*~ #* *.dvi *.aux *.eps *.bak"

#alias emacs '(setenv XMODIFIERS @im=none; \emacs \!*)'
alias emacs "(setenv XMODIFIERS @im=none; emacsclient --no-wait --alternate-editor=emacs \!*)"
alias e emacs

alias nautilus 'nautilus --no-desktop'
alias coqdoc  coqdoc --utf8

#########
# KL1
#########
alias klic "klic -I/usr/local/include -L/usr/local/lib"

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

setenv DIFF_OPTIONS "-W160 -t"
setenv BLOCKSIZE 1k
setenv PRINTER ps
setenv EDITOR emacsclient
setenv PERL_BADLANG 0


setenv PRINTER HL-2040-series
setenv SCRAMDIR /usr/scramnet/cfg/
setenv F90_BOUNDS_CHECK_ABORT YES
setenv CVSROOT /users/project/f2sim/cvsroot

set path = ( \
$HOME/bin \
/usr/local/{bin,sbin} \
/usr/freeware/{bin,sbin} \
/usr/bin/X11 \
/usr/X11R6/bin \
/usr/{bin,sbin,games} \
/{bin,sbin} \
)

### OPAM ##################
eval `opam config env`
###########################

## CABAL ##################
set path = (~/.cabal/bin $path)
###########################

if ($?prompt) then
    stty erase "^H" intr "^C" -ixon
   
    if ($?SSH_CONNECTION && ! $?SSH_TTY) then
        setenv  LC_ALL C
    else if ($TERM == kterm) then
        setenv  LC_ALL ja_JP.eucJP
        alias   more  "/usr/local/bin/jless -X"
        setenv  PAGER "/usr/local/bin/jless -X"
    else
        setenv  LC_ALL ja_JP.UTF-8
        alias   more  "/usr/bin/less -Xi"
        setenv  PAGER "/usr/bin/less -Xi"
    endif
   
    set filec
    set history = 1000
    set ignoreeof
    set mail = (/var/mail/$USER)
    set mch = `uname -n`
    set prompt = "$mch{\!}% "
    umask 000

    if ($TERM == dumb) then
        ;
    else 
        alias settitle	echo -n ']0\;${mch}:${PWD}'
        alias cd   "cd \!*; settitle"
        settitle
    endif
endif

### END OF FILE
