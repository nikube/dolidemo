# DoliDemo — Dolibarr 23.0.3 public demo instance.
#
# Base: ghcr.io/nikube/dolibarr-demo (official image + realistic demo-data
# installer overlay + DOLI_INIT_DEMO_REALISTIC / DOLI_ACTIVATE_MODULES
# entrypoint wrapper). See https://github.com/nikube/dolibarr-demo-image
#
# On top of it we pre-bundle DMM (DoliModuleManager) under /opt/extra-custom:
# the entrypoint seeds it into the custom volume on first boot, and
# DOLI_ACTIVATE_MODULES in docker-compose.yml activates it.
ARG DOLIBARR_VERSION=23.0.3
FROM ghcr.io/nikube/dolibarr-demo:${DOLIBARR_VERSION}

ARG DMM_VERSION=2.1.0

USER root
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*; \
    mkdir -p /opt/extra-custom /tmp/dmm; \
    curl -fsSL -o /tmp/dmm/dmm.zip \
      "https://github.com/nikube/DMM/releases/download/v${DMM_VERSION}/module_dolimodulemanager-${DMM_VERSION}.zip"; \
    unzip -q /tmp/dmm/dmm.zip -d /tmp/dmm/x; \
    mv /tmp/dmm/x/dolimodulemanager /opt/extra-custom/dolimodulemanager; \
    chown -R www-data:www-data /opt/extra-custom; \
    rm -rf /tmp/dmm

ENV DOLI_INIT_DEMO=0 \
    DOLI_INIT_DEMO_REALISTIC=1 \
    DOLI_ACTIVATE_MODULES=modDoliModuleManager
