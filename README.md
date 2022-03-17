# discord-notify
Sends a simple text notification to a discord server using a webhook. Useful for automated notifications and alerts.
1. [Usages](#usages)
2. [Examples](#examples)
3. [Creating Discord Webhook](#creating-discord-webhook)
4. [Installation](#installation)

## Usages
```bash
discord-notify [-vh]
discord-notify -u <url> <content>
echo <content> | discord-notify -u <url>
```
- content : The text content to send in the notification to the webhook. This is required to send notification, but it can be provided either as a positional argument or in stdin as part of a pipe.
- -u, --url : The discord webhook url to send notification to. This can be configured on discord after setting up a discord server. This is also required to send notification.
- -v, --version : Show version info.
- -h, --help : Show help text. In case you forget how to use.

### Examples
```bash
discord-notify -u https://discord.com/api/webhooks/your-discord-webhook-url "Hello World"
```
This will send the text "Hello World" to your-discord-webhook-url resulting in a "Hello World" message in a channel on your discord server. The server and channel which the message is posted to as well as the username it is posted as are all configured on the webhook.

```bash
cat your-program.log | discord-notify -u https://discord.com/api/webhooks/your-discord-webhook-url
```
This will use the cat command to output the contents of your-program.log and then pipe those contents into discord-notify. It will then send that content as a message to your-discord-webhook-url. This will work even if the contents contain multiple lines.

```bash
your-program | discord-notify -u https://discord.com/api/webhooks/your-discord-webhook-url
```
This also works when piping the direct output of a program instead of a file. I personally use this to notify me of the output of a program that I am running as a cron job.

## Creating Discord Webhook
1. Choose an existing discord server you moderate or create your own. This can be done by clicking the new server button in the bottom left-hand corner.
2. Choose an existing text channel you want to send the notifications to or create a new one. This can be done by clicking the '+' sign next to 'TEXT CHANNELS' at the top under the server name.
3. Right-click the text channel and click 'Edit Channel'.
4. On this page, navigate to Integrations > Webhooks > New Webhook
5. Change the name, avatar, and channel if needed. The name and avatar of the webhook will appear as the sender whenever a message is posted to the webhook. For example, if the purpose of the webhook is to send alerts regarding a backup job you regularly run on some machine, you can name it 'Backup Bot' so that you know it is a bot and what program sent the alert.
6. After making the needed changes, click 'Save Changes' at the bottom.
7. Then, you can click 'Copy Webhook URL' and use that with discord-notify to send messages.

## Installation
To use discord-notify, please open a terminal and run the following commands:
```bash
version=<version-to-install>
```
```bash
sudo wget \
	https://github.com/juliansangillo/discord-notify/releases/download/v${version}/discord-notify.sh \
	&& mv \
	discord-notify.sh \
	/bin/discord-notify
```
All versions are available on the releases page. You can also check the version you currently have on your machine by running `discord-notify -v`.