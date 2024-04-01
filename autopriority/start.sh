#!/system/bin/sh
# Auto Priority by Telegram @Rem01Gaming
# Powered by rish

BASEDIR="$(dirname "$0")"
DEX="$BASEDIR"/rish_shizuku.dex
TEMPFS="/data/local/tmp"
BINARY64="auto_priority64"
GAMELIST="gamelist.txt"
nice_name="com.Rem01Gaming.AutoPriority"

[[ $(uname -m) != "aarch64" ]] && echo "[-] Auto Priority only support aarch64 devices for now" && exit 1

if [ ! -f "$DEX" ]; then
	echo "[-] Cannot find $DEX, you didn't remove it right?"
	exit 1
fi

if [ ! -f ${BASEDIR}/${BINARY64} ] || [ ! -f ${BASEDIR}/${GAMELIST} ]; then
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

# Check if libwordexp is installed
if [[ $(pkg list-installed) != *libandroid-wordexp* ]]; then
	echo "[*] Installing libwordexp..."
	apt install libandroid-wordexp
	if [[ $(pkg list-installed) != *libandroid-wordexp* ]]; then
		echo "[-] Can't install libwordexp." && exit 1
	fi
fi

echo "[*] Running rish API..."
[ -z "$RISH_APPLICATION_ID" ] && export RISH_APPLICATION_ID="com.termux"
/system/bin/app_process -Djava.class.path="$DEX" /system/bin --nice-name=$nice_name rikka.shizuku.shell.ShizukuShellLoader -c "cp ${BASEDIR}/${BINARY64} ${TEMPFS} && cp ${BASEDIR}/${GAMELIST} ${TEMPFS} && chmod +x ${TEMPFS}/${BINARY64}"
[ -w ${TEMPFS}/${BINARY64} ] && echo "[-] Can't copy binary to tempfs" && exit 255
nohup /system/bin/app_process -Djava.class.path="$DEX" /system/bin --nice-name=$nice_name rikka.shizuku.shell.ShizukuShellLoader -c "${TEMPFS}/${BINARY64}" >/dev/null 2>&1 &
echo "[+] Successfully launch Auto Priority"
