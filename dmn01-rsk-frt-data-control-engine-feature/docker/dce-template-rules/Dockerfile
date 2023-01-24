FROM harbor.mgmt-bld.oncp.dev/platform_tools/docker-dind-gcloud:v1.2.0

LABEL workstream="dmn01-rskcda" \
      maintainer="dmn01-rskcda" \
      email="jacob.harden@e.lloydsbanking.com"

ARG USER=appuser
ENV HOME_DIR=/home/${USER}

RUN adduser -D -h ${USER} ${USER} ${USER}

# COPY RULE FILES
COPY ./artifacts/domain/config ${HOME_DIR}/rules
COPY ./docker/dce-template-rules/bin/load_rules.sh $HOME_DIR/load_rules.sh

RUN apk upgrade --update-cache --available \
    && apk add openssl \
    && apk del zlib libtirpc \
    && rm -rf /var/cache/apk/* \
    && chown -R ${USER}:${USER} ${HOME_DIR} \
    && chmod +x ${HOME_DIR}/load_rules.sh \
    && sed -i -e 's/"disable_updater": false,/"disable_updater": true,/' /opt/google-cloud-sdk/lib/googlecloudsdk/core/config.json

USER ${USER}
# SET WORK DIR
WORKDIR ${HOME_DIR}

ENTRYPOINT ["./load_rules.sh"]