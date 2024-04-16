# Default (SSH) gateway

gw="$TUNNEL_GATEWAY_HOST"
# if not empty
[ "X$TUNNEL_GATEWAY_USER" = X ] || gw="$TUNNEL_GATEWAY_USER@$TUNNEL_GATEWAY_HOST"

# if not empty
if [ -n "$SSH_KEY" ]; then
  KEY_FILE=$(mktemp --suffix=.pem)
  trap 'rm -f -- "$KEY_FILE"' EXIT
  echo "${SSH_KEY@E}" > "$KEY_FILE"
  chmod 600 "$KEY_FILE"
  SSH_KEY_PARAM="-i $KEY_FILE"
fi

$TUNNEL_SSH_CMD \
  -N \
  -L "$TUNNEL_LOCAL_HOST:$TUNNEL_LOCAL_PORT:$TUNNEL_TARGET_HOST:$TUNNEL_TARGET_PORT" \
  -p "$TUNNEL_GATEWAY_PORT" \
  $SSH_KEY_PARAM \
  "$gw" &

TUNNEL_PID=$!
