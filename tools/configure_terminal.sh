#!/usr/bin/env bash
#
# Xresources => gnome-terminal, guake
#
# https://github.com/Anthony25/gnome-terminal-colors-solarized
# https://github.com/coolwanglu/guake-colors-solarized
# https://github.com/nodiscc/scriptz/blob/master/utility/convert-xresources-to-gnome-terminal.sh
#
# License: MIT (http://opensource.org/licenses/MIT)
#
XRESFILE="$HOME/.Xresources"
TEMPFILE=""
ARRAY=""

grep -q "define" "$XRESFILE"
if [ "$?" = 0 ]
    then echo "cpp-style file detected"
    TEMPFILE=`mktemp`
    cpp < "$XRESFILE" > "$TEMPFILE"
    XRESFILE="$TEMPFILE"
fi

number=0
while [ $number -lt 16 ]
do
    ARRAY=`echo $ARRAY ; egrep "URxvt.color$number|*color$number\:" $XRESFILE | awk '{print $NF}'`
    number=$(($number+1))
done

GCONFVALUE=`echo $ARRAY | sed 's/\ /\:/g'`
DCONFVALUE="'`echo $ARRAY | sed "s/\ /'\,'/g"`'"
X_BACKGROUNDVALUE=`grep background $XRESFILE | awk '{print $NF}'`
X_FOREGROUNDVALUE=`grep foreground $XRESFILE | awk '{print $NF}'`

BACKGROUNDVALUE_PART1=${X_BACKGROUNDVALUE:1:2}
BACKGROUNDVALUE_PART2=${X_BACKGROUNDVALUE:3:2}
BACKGROUNDVALUE_PART3=${X_BACKGROUNDVALUE:5:2}
BACKGROUNDVALUE="#$BACKGROUNDVALUE_PART1$BACKGROUNDVALUE_PART1$BACKGROUNDVALUE_PART2$BACKGROUNDVALUE_PART2$BACKGROUNDVALUE_PART3$BACKGROUNDVALUE_PART3"

FOREGROUNDVALUE_PART1=${X_FOREGROUNDVALUE:1:2}
FOREGROUNDVALUE_PART2=${X_FOREGROUNDVALUE:3:2}
FOREGROUNDVALUE_PART3=${X_FOREGROUNDVALUE:5:2}
FOREGROUNDVALUE="#$FOREGROUNDVALUE_PART1$FOREGROUNDVALUE_PART1$FOREGROUNDVALUE_PART2$FOREGROUNDVALUE_PART2$FOREGROUNDVALUE_PART3$FOREGROUNDVALUE_PART3"

# gnome version >= 3.8
PROFILE=$(dconf read /org/gnome/terminal/legacy/profiles:/default | sed "s/'//g")
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/use-theme-colors "false"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/bold-color-same-as-fg "true"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/palette "[$DCONFVALUE]"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/foreground-color "'$FOREGROUNDVALUE'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE/background-color "'$BACKGROUNDVALUE'"

# gnome version less than 3.8 use the following
#gconftool-2 --set --type bool /apps/gnome-terminal/profiles/Default/use_theme_colors false
#gconftool-2 --set --type bool /apps/gnome-terminal/profiles/Default/bold_color_same_as_fg false
#gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/palette "$GCONFVALUE"
#gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/foreground_color "$FOREGROUNDVALUE"
#gconftool-2 --set --type string /apps/gnome-terminal/profiles/Default/background_color "$BACKGROUNDVALUE"

# guake
gconftool-2 --set --type string /apps/guake/style/font/color "$FOREGROUNDVALUE"
gconftool-2 --set --type string /apps/guake/style/background/color "$BACKGROUNDVALUE"
gconftool-2 --set --type string /apps/guake/style/font/palette "$GCONFVALUE"

echo "Colors set to $GCONFVALUE"
echo "Foreground set to $FOREGROUNDVALUE"
echo "Background set to $BACKGROUNDVALUE"

if [ -f "$TEMPFILE" ]
    then rm "$TEMPFILE"
fi
