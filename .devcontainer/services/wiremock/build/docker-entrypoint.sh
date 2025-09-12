#!/bin/bash

set -e

# WireMock’un çalışacağı dizini, varsayılan olarak /home/wiremock yap.
# Ama istersen WIREMOCK_DIRECTORY ortam değişkeni ile değiştirebilirsin.
wiremock_dir="${WIREMOCK_DIRECTORY:-/home/wiremock}"

# GRPC eklentisinin ihtiyaç duyduğu dizini oluştur
mkdir -p "$wiremock_dir/grpc"


# WireMock’un JAR dosyası (wiremock-standalone-3.13.1.jar) içinde bir Java sınıfı var: wiremock.Run.
# Bu sınıf, WireMock’u başlatmak için main metodunu içeriyor.
# Yani terminalde normalde şöyle çalıştırırdın:
# java -cp wiremock-standalone-3.13.1.jar wiremock.Run --port 8080
#
# docker run wiremock ... gibi parametreler verilirse, otomatik olarak WireMock’u başlatacak komutu ayarlıyor:
# java $JAVA_OPTS -cp /var/wiremock/lib/*:/var/wiremock/extensions/* wiremock.Run "$@"
# $@ kısmı, container’a eklenen argümanları (--port 8080, --verbose vs.) geçiriyor.
#
# Set `java` command if needed
if [ "$1" = "" -o "${1:0:1}" = "-" ]; then
  set -- java $JAVA_OPTS -cp /var/wiremock/lib/*:/var/wiremock/extensions/* wiremock.Run "$@"
fi

# allow the container to be started with `-e uid=`
if [ "$uid" != "" ]; then
  # Change the ownership of /home/wiremock to $uid
  chown -R $uid:$uid $wiremock_dir
  set -- gosu $uid:$uid "$@"
fi
# Buradaki mantık: eğer container başlatılırken bir uid verilirse (örn. -e uid=1001),
# WireMock işlemlerini o UID ile çalıştır.
# Ama bu `chown -R $uid:$uid /home/wiremock` kısmı, `/home/wiremock` dizini yoksa patlıyor.

exec "$@" $WIREMOCK_OPTIONS
