#!/bin/bash
# Entrypoint wrapper on top of docker-init-demo.sh (base image): once the
# base wrapper has activated the modules (modCron among them), store the
# cron security key so the cron sidecar is accepted.
if [ -n "${DOLI_CRON_KEY}" ]; then
	(
		MLOG=/var/www/documents/activate-modules.log
		until [ -f "$MLOG" ] && grep -q "modCron" "$MLOG" 2>/dev/null; do sleep 10; done
		sleep 2
		if su www-data -s /bin/sh -c "php /var/www/html/install/set-cron-key.php '${DOLI_CRON_KEY}'"; then
			echo "[dolidemo] CRON_KEY stored"
		else
			echo "[dolidemo] ERROR: could not store CRON_KEY"
		fi
	) &
fi
exec docker-init-demo.sh "$@"
