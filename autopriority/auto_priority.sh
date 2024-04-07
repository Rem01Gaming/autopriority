#!/system/bin/sh

BASEDIR="$(dirname "$0")"
game_list_filter="com.example.gamelist1|com.example.gamelist2$(awk '!/^[[:space:]]*$/ && !/^#/ && !(/[[:alnum:]]+[[:space:]]+[[:alnum:]]+[[:space:]]+[[:alnum:]]+/) {sub("-e ", ""); printf "|%s", $0}' "${BASEDIR}/gamelist.txt")"

apply_priority() {
	echo "Niceness of $1: $(ps -o ni= -p $1 | grep -oE '[^[:space:]]+')"
	if [ $(ps -o ni= -p $1 | grep -oE '[^[:space:]]+') -gt -20 ]; then
		echo "Optimizing ${1}..."
		renice -n -20 -p $1
		ionice -c 1 -n 0 -p $1
	else
		echo "$1 is already optimized"
	fi
}

priority_mon() {
	while true; do
		echo "Try to catch game process..."
		window="$(/system/bin/dumpsys window)"
		gamestart=$(echo "$window" | grep -E 'mCurrentFocus|mFocusedApp' | grep -Eo "$game_list_filter" | tail -n 1)
		screenoff=$(echo "$window" | grep mScreen | grep -Eo "false" | tail -n 1)
		if [ ! -z "$gamestart" ] && [[ "$screenoff" != "false" ]]; then
			echo "$gamestart is a game, Optimizing..."
			pid="$(pidof $gamestart)"
			apply_priority $pid
		fi
		sleep 10
	done
}

/system/bin/cmd notification post -S bigtext -t \"Auto Priority\" "Tag$(date +%s)" \"Successfully launch Auto Priority\" >/dev/null 2>&1
priority_mon
