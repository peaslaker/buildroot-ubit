# ~/.bashrc: executed by bash(1) for non-login interactive shells.

export PATH=\
/bin:\
/sbin:\
/usr/bin:\
/usr/sbin:\
/usr/local/bin

# If running interactively, then:
if [ "$PS1" ]; then

    if [ "`id -u`" -eq 0 ]; then 
      export PS1='\h:\w\# '
    else
      export PS1='\h:\w\$ '
    fi

    export USER=`id -un`
    export LOGNAME=$USER
    export HOSTNAME=`/bin/hostname`
    export HISTSIZE=1000
    export HISTFILESIZE=1000
    export PAGER='/bin/more '
    export EDITOR='/bin/vi'
    export INPUTRC=/etc/inputrc

fi;
