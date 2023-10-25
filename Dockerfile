FROM alpine:latest as base

RUN apk add --no-cache build-base cmake automake \
        autoconf libtool pkgconf coreutils \
        curl unzip gettext-tiny-dev git libgcc

RUN echo -e "nameserver 8.8.8.8" > /etc/resolv.conf && \
  git clone https://github.com/neovim/neovim.git && \
  cd neovim && \
  make && \
  make install && \
  cd ../ && rm -rf neovim 

RUN apk del build-base cmake automake \
        autoconf libtool pkgconf coreutils \
        curl unzip gettext-tiny-dev

RUN apk add --no-cache go nodejs-current openjdk17 npm \
        gcc fzf ripgrep python3 py3-pip maven

RUN go install golang.org/x/tools/gopls@latest

RUN apk add --no-cache bash

FROM base as compilers

RUN apk add --no-cache clang g++

FROM compilers as dotfiles

RUN git clone https://github.com/pedrohms/dotfiles && \
    mkdir /root/.config && \
    cp -Rf dotfiles/config/nvim_lazy/.config/nvim /root/.config/ && \
    rm -Rf /root/dotfiles

ENV PATH=$PATH:/root/go/bin
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV NVIM_FULL=1
ENTRYPOINT ["nvim"]
