#!/bin/bash
#
# Little script to add live reload to any project. The browser
# will automatically refresh the page when any files are changed
# in the watch directory.
#
# usage:
#   live-server.sh <watch-directory>
#
# depends on:
#   entr: http://eradman.com/entrproject/
#   websocat: https://github.com/vi/websocat
#
# The following client side javascript needs to be in your page.
# It can be anywhere, even after the </html> tag.
#
#<script>
#    // Client-side script to reload the page when connection
#    // with live-reload websocket is lost.
#    (() => {
#        const socketUrl = "ws://localhost:8765";
#        const socket = new WebSocket(socketUrl);
#        socket.addEventListener('close', () => {
#            const maxAttempts = 3;
#            let backoff = 2000;
#            let attempts = 0;
#            const tryReconnect = () => {
#                attempts++;
#                if (attempts > maxAttempts) {
#                    console.error(
#                        "Could not reconnect to live-reload socket."
#                        + " Check the server and refresh manually."
#                    );
#                    return;
#                }
#                const socket = new WebSocket(socketUrl);
#                socket.addEventListener('error', () => {
#                    setTimeout(tryReconnect, backoff);
#                    backoff *= 2;
#                });
#                socket.addEventListener('open', () => {
#                    location.reload();
#                });
#            };
#            tryReconnect();
#        });
#    })();
#</script>
#

if [ $# -ne 1 ]; then
cat << EOF
usage:
  live-server.sh <watch-directory>
EOF
exit 1
fi

(trap 'kill 0' SIGINT; python3 -m http.server -d ${1} & find ${1} -type f | entr -r websocat -s 8765 & wait)

