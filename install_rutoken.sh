#!/bin/sh

# see https://www.altlinux.org/КриптоПро

# TODO: only if not root
SUDO=sudo

BIARCH=''
[ "$(distro_info -a)" = "x86_64" ] && BIARCH="i586-"

fatal()
{
    echo "FATAL: $*" >&2
    exit 1
}

info()
{
    echo "$*"
}


DEVEL=''
if [ "$1" = "--devel" ] ; then
    DEVEL=1
    shift
fi

INSTALL32=''
INSTALL64=''
case "$1" in
    32)
        INSTALL32="$1"
        ;;
    64)
        INSTALL64="$1"
        ;;
    both)
        INSTALL32="$1"
        INSTALL64="$1"
        ;;
    *)
        fatal "Run with 32|64|both param"
esac

if [ -n "$INSTALL64" ] ; then

    # ruToken support
    # instead of cryptopro-preinstall, see https://www.altlinux.org/КриптоПро#Установка_пакетов
    epmi pcsc-lite-rutokens pcsc-lite-ccid librtpkcs11ecp

    # TODO:
    # Почему у нас токены через pcscd?
    # Зачем тогда cprocsp-rdr-rutoken ?
    # Какие пакеты нужны для токена? Отделить отсюда?
    # Ответ: Современные аппаратные и программно-аппаратные хранилища ключей, такие как Рутокен ЭЦП или eSmart ГОСТ, поддерживаются через интерфейс PCSC
fi

if [ -n "$INSTALL32" ] ; then

    # ruToken support
    # instead of cryptopro-preinstall, see https://www.altlinux.org/КриптоПро#Установка_пакетов
    epmi ${BIARCH}pcsc-lite-rutokens ${BIARCH}pcsc-lite-ccid ${BIARCH}librtpkcs11ecp
fi

# Кто использует?
#epmi newt52

epmi opensc
epmi pcsc-lite

echo "Enabling pcscd service ..."
serv pcscd on
