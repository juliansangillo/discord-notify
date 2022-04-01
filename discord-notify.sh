#! /bin/bash

IFS=$"\n"

version=1.1
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

lines=()
if [ ! -z "${pos[0]}" ]; then
	lines+=("${pos[0]}")
elif [ ! -t 0 ]; then
	while read line ; do
		lines+=("${line}")
	done < /dev/stdin
fi

if [[ -z "${lines[@]}" ]]; then
	log_error "content is required. Please provide some content and try again." -h
	exit 1
fi

if [ -z "$url" ]; then
	log_error "url is required. Please provide a url and try again." -h
	exit 1
fi

limit=2000
messages=()
message=""
for line in "${lines[@]}" ; do
	if [ $(( ${#message} + ${#line} )) -gt $limit ]; then
		messages+=("$message")
		message="$line"
	else
		message="${message}${line}\n"
	fi
done
messages+=("$message")

count="${#messages[@]}"
for i in "${!messages[@]}"; do
	curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"${messages[$i]}\"}" $url
	if [ $count -gt 1 ]; then
		curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"$(( i + 1 ))/$count\"}" $url
	fi
done

log_out "sent."
