#!/system/bin/sh
# This file is part of Auto Priority.
#
# Auto Priority is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Auto Priority is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Auto Priority.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2024 Rem01Gaming

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
			pid="$(pgrep -f $gamestart)"
                        pgrep -f "$gamestart" | while read -r pid; do
                        apply_priority "$pid"
                        done
		fi
		sleep 10
	done
}

/system/bin/cmd notification post -S bigtext -t \"Auto Priority\" "Tag$(date +%s)" \"Successfully launch Auto Priority\" >/dev/null 2>&1
priority_mon
