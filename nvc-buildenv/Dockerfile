FROM ubuntu:20.04 as nvcbuilder

LABEL maintainer="Filip Filmar <filmil@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install --no-install-recommends \
    autoconf \
    autogen \
    bison \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    default-jdk \
    flex \
    git \
    gperf \
    help2man \
    libdw-dev \
    libffi-dev \
    libreadline-dev \
    libz-dev \
    libzstd-dev \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    tcl-dev \
    uuid-dev \
    zlib1g-dev \
    && \
    rm -rf /var/lib/apt/lists/*


####
FROM nvcbuilder as llvmbuild

RUN mkdir -p /git
WORKDIR /git
RUN git clone https://github.com/llvm/llvm-project.git

WORKDIR /git/llvm-project
RUN git checkout "llvmorg-15.0.7"

RUN mkdir -p /build
WORKDIR /build

RUN mkdir llvm-project
WORKDIR /build/llvm-project
RUN cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/install/llvm \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DLLVM_ENABLE_PROJECTS=llvm \
  /git/llvm-project/llvm
RUN cmake --build . -j 50 --target install

####
FROM nvcbuilder as nvcbuildenv

COPY --from=llvmbuild /install /install

RUN apt-get update && apt -y install --no-install-recommends \
    autotools-dev \
    automake \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /git
RUN git clone --depth=1 https://github.com/nickg/nvc nvc
WORKDIR /git/nvc
RUN ./autogen.sh

RUN mkdir -p /build/nvc
WORKDIR /build/nvc
RUN ls -l /
RUN /git/nvc/configure \
  --prefix=/install/nvc \
  --enable-static-llvm \
  --with-llvm=/install/llvm/bin/llvm-config \
  --disable-default-paths
RUN make install

COPY --from=nvcbuilder \
  /lib/x86_64-linux-gnu \
  /instal/x86_64-linux-gnu

COPY copier.sh /

VOLUME ["/src"]
WORKDIR /src

