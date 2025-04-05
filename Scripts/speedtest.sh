#!/usr/bin/env bash
set -eo pipefail

SCRIPTS_PATH=/media/fat/Scripts
INSTALL_PATH=${SCRIPTS_PATH}/.config/speedtest
ST_VERSION=1.2.0
ST_VER_FILE=${INSTALL_PATH}/speedtest_version
ST_DL=https://install.speedtest.net/app/cli/ookla-speedtest-${ST_VERSION}-linux-armhf.tgz
ST_DL_TMP_DIR=/tmp
ST_DL_TMP=${ST_DL_TMP_DIR}/speedtest.tgz

ST_ARGS="--progress=yes"

[ -f ${SCRIPTS_PATH}/speedtest.ini ] && source ${SCRIPTS_PATH}/speedtest.ini

[ -d ${INSTALL_PATH} ] || mkdir -p ${INSTALL_PATH}

if ! [ -f ${INSTALL_PATH}/speedtest ] || [ "${ST_VERSION}" != "$(< ${ST_VER_FILE})" ]; then
  echo "Downloading speedtest v${ST_VERSION}..."
  wget ${ST_DL} -O ${ST_DL_TMP}
  echo "Installing speedtest to ${INSTALL_PATH}..."
  cd ${ST_DL_TMP_DIR}
  tar xf ${ST_DL_TMP} speedtest
  chown root:root ${ST_DL_TMP_DIR}/speedtest
  mv ${ST_DL_TMP_DIR}/speedtest ${INSTALL_PATH}
  rm -f ${ST_DL_TMP}
  cd ~-
  echo "${ST_VERSION}" > ${ST_VER_FILE}
fi

printf "YES\n" | ${INSTALL_PATH}/speedtest ${ST_ARGS} | tee ${ST_DL_TMP_DIR}/speedtest.out

echo "  Result URL QR Code:"
${INSTALL_PATH}/qrencode $(grep -oE "https://www.speedtest.net/result/c/.*" ${ST_DL_TMP_DIR}/speedtest.out) -t ansiutf8

rm -f ${ST_DL_TMP_DIR}/speedtest.out
