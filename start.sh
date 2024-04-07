#!/system/bin/sh
# Auto Priority by Telegram @Rem01Gaming
# Powered by rish

BASEDIR="$(dirname "$0")"
DEX="$BASEDIR"/rish_shizuku.dex
SCRIPT="auto_priority.sh"
GAMELIST="gamelist.txt"
nice_name="com.Rem01Gaming.AutoPriority"

if [ ! -f "$DEX" ] || [ ! -f ${BASEDIR}/${SCRIPT} ] || [ ! -f ${BASEDIR}/${GAMELIST} ]; then
	echo "[-] Cannot find Auto Priority files, you didn't remove it right?"
	exit 1
fi

if [ $(getprop ro.build.version.sdk) -ge 34 ]; then
	if [ -w $DEX ]; then
		echo "[-] On Android 14+, app_process cannot load writable dex."
		echo "[*] Attempting to remove the write permission..."
		chmod 400 $DEX
	fi
	if [ -w $DEX ]; then
		echo "[-] Cannot remove the write permission of $DEX."
		echo "[*] You can copy to file to terminal app's private directory (/data/data/<package>, so that remove write permission is possible"
		exit 1
	fi
fi

echo "[*] Running rish API..."
[ -z "$RISH_APPLICATION_ID" ] && export RISH_APPLICATION_ID="com.termux"
nohup /system/bin/app_process -Djava.class.path="$DEX" /system/bin --nice-name=$nice_name rikka.shizuku.shell.ShizukuShellLoader -c "/system/bin/sh ${BASEDIR}/${SCRIPT}" >/dev/null 2>&1 &
sleep 2

# Check if Auto Priority running properly
pgrep $nice_name >/dev/null 2>&1
if [ $? -eq 0 ]; then
	echo "[+] Successfully launch Auto Priority"
else
	echo "[-] Unexpected error while running Auto Priority"
fi
