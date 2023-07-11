is_mounted() {
	mount | awk -v DIR="$1" '{if ($3 == DIR) { exit 0}} ENDFILE{exit -1}'
}

if ! is_mounted "/mnt/storage"; then
	sudo mount /mnt/storage
fi

if ! is_mounted "/mnt/storage"; then
	echo Backup drive is not mounted
	exit 0
fi
echo "Drive mounted... let's go"

rclone sync -v \
	--ignore-errors \
	--stats 10s \
	--stats-log-level INFO \
    /mnt/storage/media/tv/ \
    box-media-large:/tv/
