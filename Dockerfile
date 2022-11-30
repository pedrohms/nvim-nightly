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
        gcc fzf ripgrep python3 py3-pip

RUN go install golang.org/x/tools/gopls@latest

RUN apk add --no-cache bash

ENV PATH=$PATH:/root/go/bin
ENTRYPOINT ["nvim"]
