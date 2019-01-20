FROM debian:stable-20181226
# FROM ubuntu:18.10

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN apt-get update && \
    apt-get install -y libtool libusb-1.0.0-dev librtlsdr-dev rtl-sdr tzdata git build-essential && \
    apt-get install -y autoconf cmake pkg-config

WORKDIR /usr/local/
RUN git clone https://github.com/merbanan/rtl_433.git && cd rtl_433 && git checkout 3af2b4af1b503718e71170628a794ddd6d093a35
RUN cd rtl_433/ && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make
WORKDIR /usr/local/rtl_433/build/src/

ENTRYPOINT /usr/local/rtl_433/build/src/rtl_433 -F csv:/data/log.csv || echo "No USB Device found"
