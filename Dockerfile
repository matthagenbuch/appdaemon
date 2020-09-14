FROM ubuntu:20.04

# Environment vars we can configure against
# But these are optional, so we won't define them now
#ENV HA_URL http://hass:8123
#ENV HA_KEY secret_key
#ENV DASH_URL http://hass:5050
#ENV EXTRA_CMD -D DEBUG

# API Port
EXPOSE 5050

# Mountpoints for configuration & certificates
VOLUME /conf
VOLUME /certs

# Copy appdaemon into image
WORKDIR /usr/src/app
COPY . .

RUN apt-get update && apt-get -y upgrade

ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apt-get -y install tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get -y install \
    python3.8 \
    python3.8-dev \
    python3-pip \
    gcc \
    libffi-dev \
    libssl-dev \
    musl-dev \
    curl

RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir .
RUN pip3 install --no-cache-dir \
    numpy \
    pillow \
    py-synology \
    scikit-image \
    https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp38-cp38-linux_x86_64.whl

# Start script
RUN chmod +x /usr/src/app/dockerStart.sh
ENTRYPOINT ["./dockerStart.sh"]
