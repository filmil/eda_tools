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
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_INSTALL_PREFIX=/install/llvm \
  -DLLVM_TARGETS_TO_BUILD=host \
  -DLLVM_ENABLE_PROJECTS=llvm \
  -DBUILD_SHARED_LIBS=ON \
  /git/llvm-project/llvm
RUN cmake --build . -j --target install

####
FROM nvcbuilder as nvcbuildenv

COPY --from=llvmbuild /install /install

RUN apt-get update && apt -y install --no-install-recommends \
    automake \
    autotools-dev \
    gawk \
    gdb \
    less \
    libbz2-dev \
    libelf-dev \
    liblzma-dev \
    llvm \
    && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run

WORKDIR /git
RUN git clone --depth=1 https://github.com/nickg/nvc nvc
RUN git clone --depth=1 https://github.com/brandt/symlinks
RUN git clone --depth=1 https://github.com/cuviper/elfutils

WORKDIR /git/symlinks
RUN env CFLAGS="-static" make
RUN mkdir -p /install
RUN cp symlinks /run


RUN mkdir -p /build/elfutils
WORKDIR /git/elfutils
RUN autoreconf -i -f
WORKDIR /build/elfutils
RUN \
  env CFLAGS="-w" \
    CXXFLAGS="-w" \
  /git/elfutils/configure \
  --enable-maintainer-mode \
  --prefix=/install/elftools
RUN make install -j


WORKDIR /git/nvc
RUN ./autogen.sh


RUN mkdir -p /build/nvc
WORKDIR /build/nvc
RUN \
  env LDFLAGS="-static -static-libgcc \
      -static-libstdc++ -fno-lto" \
    libdw_LIBS="-ldw -lelf -lbz2 -llzma -lebl" \
    CXXFLAGS="-ggdb" \
    CFLAGS="-ggdb" \
    CC="clang" \
    CXX="clang++" \
  /git/nvc/configure \
  --prefix=/install/nvc \
  --with-llvm=/install/llvm/bin/llvm-config \
  --disable-default-paths
RUN make install -j

RUN /run/symlinks -c /lib/x86_64-linux-gnu

COPY --from=nvcbuilder \
  /lib/x86_64-linux-gnu \
  /install/x86_64-linux-gnu

COPY copier.sh /
RUN chmod a+rx /copier.sh
RUN ls -l /copier.sh

VOLUME ["/src"]
WORKDIR /src

