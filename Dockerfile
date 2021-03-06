FROM debian:stable-slim

LABEL maintainer "petr.safarcik@thybit.com"

ARG deb=java-1.8.0-amazon-corretto-jdk_8.202.08-2_amd64.deb
ARG path=https://d2znqt9b1bc64u.cloudfront.net

# TODO: BUG - https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
# In addition to installing the DEB, we also install
# fontconfig. The folks who manage the docker hub's
# official image library have found that font management
# is a common usecase, and painpoint, and have
# recommended that Java images include font support.
#
# See:
#  https://github.com/docker-library/official-images/blob/master/test/tests/java-uimanager-font/container.java

RUN mkdir -p /usr/share/man/man1 \
 && apt-get update \
 && apt-get install -y wget \
 && wget $path/$deb \
 && apt-get update \
 && apt-get install java-common \
 && dpkg --install $deb \
 && apt-get install fontconfig -y \
 && apt-get -y install gettext-base \
 # cleanup
 && apt-get remove --purge wget -y \
 # && apt-get autoremove -y -f \
 && apt-get clean -y \
 && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* \
 && rm $deb \
 && java -version