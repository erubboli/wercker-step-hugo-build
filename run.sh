#/bin/bash

LATEST_HUGO_VERSION=0.14

# check if curl is installed
# Install otherwise
if [ "$(which curl)" == "" ]; then
    if [ "$(which apt-get)" != "" ]; then
        apt-get update
        apt-get install -y curl
    else
        yum install -y curl
    fi
fi

if [ "$WERCKER_HUGO_BUILD_VERSION" == "false" ]; then
    echo "The Hugo version in your wercker.yml isn't set correctly. Please put quotes around it. We will continue using the latest version ($LATEST_HUGO_VERSION)."
    export WERCKER_HUGO_BUILD_VERSION=""
fi

if [ ! -n "$WERCKER_HUGO_BUILD_VERSION" ]; then
    export WERCKER_HUGO_BUILD_VERSION=$LATEST_HUGO_VERSION
fi

if [ ! -n "$WERCKER_HUGO_BUILD_FLAGS" ]; then
    WERCKER_HUGO_BUILD_FLAGS=""
fi
if [ -n "$WERCKER_HUGO_BUILD_THEME" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --theme="${WERCKER_HUGO_BUILD_THEME}
fi

if [ -n "$WERCKER_HUGO_BUILD_CONFIG" ]; then
    WERCKER_HUGO_BUILD_FLAGS=$WERCKER_HUGO_BUILD_FLAGS" --config="${WERCKER_SOURCE_DIR}/${WERCKER_HUGO_BUILD_CONFIG}
fi

cd $WERCKER_STEP_ROOT
curl -L https://github.com/spf13/hugo/releases/download/v${WERCKER_HUGO_BUILD_VERSION}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz -o ${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
tar xzf hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64.tar.gz
${WERCKER_STEP_ROOT}/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64/hugo_${WERCKER_HUGO_BUILD_VERSION}_linux_amd64 --source="${WERCKER_SOURCE_DIR}" ${WERCKER_HUGO_BUILD_FLAGS}
