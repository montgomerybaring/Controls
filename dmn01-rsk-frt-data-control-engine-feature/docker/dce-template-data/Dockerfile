FROM harbor.mgmt-bld.oncp.dev/platform_tools/docker-dind-gcloud:v1.2.0

LABEL workstream="dmn01-rskcda" \
    maintainer="dmn01-rskcda" \
    email="jacob.harden@e.lloydsbanking.com"

ARG USER=appuser
ENV HOME_DIR=/home/${USER}

RUN adduser -D -h ${USER} ${USER} ${USER}

# COPY DATA FILES
COPY artifacts/domain/data/test_data ${HOME_DIR}/data
COPY docker/dce-template-data/bin/load_data.sh ${HOME_DIR}/

RUN apk upgrade --update-cache --available \
    && apk add openssl \
    && apk del zlib libtirpc \
    && rm -rf /var/cache/apk/* \
    && chown -R ${USER}:${USER} ${HOME_DIR} \
    && chmod +x ${HOME_DIR}/load_data.sh \
    && sed -i -e 's/"disable_updater": false,/"disable_updater": true,/' /opt/google-cloud-sdk/lib/googlecloudsdk/core/config.json

USER ${USER}
# SET WORK DIR
WORKDIR ${HOME_DIR}

ENTRYPOINT ["./load_data.sh"]
