#!/bin/bash
ARCH=$1
JAVA_VERSION=$2

PACKAGES=()
PACKAGES_HOST=(
build-essential \
     autoconf \
     automake \
     libtool \
     curl \
     git \
     zip \
     unzip \
     nasm \
     g++ \
     gcc \
)
case "$ARCH" in
  "x86")
    DEBARCH=i386
    ;;
  "x86-64")
    DEBARCH=amd64
    ;;
  "arm64")
    DEBARCH=arm64
    GNUARCH=aarch64
    ;;
  "ppc64el")
    DEBARCH=ppc64el
    GNUARCH=powerpc64le
    ;;
esac

if [[ "$GNUARCH" == "" ]]; then
    PACKAGES_HOST+=(g++-multilib gcc-multilib)
else
    PACKAGES_HOST+=("libgcc-7-dev:$DEBARCH" "g++-$GNUARCH-linux-gnu" "gcc-$GNUARCH-linux-gnu")
fi;

apt-get update && \
 apt-get install -o Debug::pkgProblemResolver=true -y "${PACKAGES_HOST[@]}" && \
 rm -rf /var/lib/apt/lists/*

PACKAGES+=(
     "libasound2-dev:$DEBARCH" \
     "libpulse-dev:$DEBARCH" \
     "libx11-dev:$DEBARCH" \
     "libxext-dev:$DEBARCH" \
     "libxt-dev:$DEBARCH" \
     "libxv-dev:$DEBARCH" \
     "openjdk-$JAVA_VERSION-jdk:$DEBARCH")

dpkg --add-architecture $DEBARCH
apt-get update && \
 apt-get install -o Debug::pkgProblemResolver=true -y "${PACKAGES[@]}" && \
 rm -rf /var/lib/apt/lists/*
