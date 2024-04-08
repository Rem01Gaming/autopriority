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
SCRIPT="auto_priority.sh"
GAMELIST="gamelist.txt"

if [ ! -f ${BASEDIR}/${SCRIPT} ] || [ ! -f ${BASEDIR}/${GAMELIST} ]; then
	echo "[-] Cannot find Auto Priority files, you didn't remove it right?"
	exit 1
fi

nohup /system/bin/sh ${BASEDIR}/${SCRIPT} >/dev/null 2>&1 &
echo "[+] Successfully launch Auto Priority"
echo "[*] It's save to exit your terminal, Auto Priority will run in background."
