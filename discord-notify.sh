#! /bin/bash

version=1.0
version_info="discord-notify version $version"

help_text="Usage: discord-notify [-vh]
Usage: discord-notify -u <url> <content>
Usage: echo <content> | discord-notify -u <url>

Sends a simple text notification to a discord server using a webhook. Useful for 
automated notifications and alerts.

Required:
	content			Text content to send in the notification. This can be
				passed in as a positional argument or piped into stdin.
	-u, --url		Discord webhook url to send notification to.

Flags:
	-v, --version		Show version info
	-h, --help		Show this help text."

function log_out {
	echo "discord-notify: $1"
}

function log_error {
	echo "discord-notify: error: $1" >&2
	if [ "$2" == "-h" ]; then
		echo
		echo "$help_text"
	fi
}

pos=()
while (( "$#" )); do
	case "$1" in
		-h|--help) echo "$help_text" && exit 0;;
		-v|--version) echo "$version_info" && exit 0;;
		-u|--url) 
			if [[ -z "$2" || " -h --help -u --url -s --show_status " =~ " $2 " ]]; then
				log_error "url must have a value" -h
				exit 1
			fi
			url="$2"
			shift 2
			;;
		*)
			pos+=("$1")
			shift
			;;
	esac
done

if [ ! -z "${pos[0]}" ]; then
	content="${pos[0]}"
elif [ ! -t 0 ]; then
	content=""
	while read line ; do
		content="${content}${line}\n"
	done < /dev/stdin
fi

if [ -z "$content" ]; then
	log_error "content is required. Please provide some content and try again." -h
	exit 1
fi

if [ -z "$url" ]; then
	log_error "url is required. Please provide a url and try again." -h
	exit 1
fi

curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$content\"}" $url
if [ $? -ne 0 ]; then
	log_error "failed to send. Please check logs and try again."
	exit 2
fi
log_out "sent."
