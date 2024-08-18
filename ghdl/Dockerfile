# COMMON BUILDER
FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install --no-install-recommends \
    bash \
    ghdl \
    ""

VOLUME ["/workspace"]
WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
