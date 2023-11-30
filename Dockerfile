FROM alpine:edge as base

RUN apk add --no-cache build-base cmake automake \
        autoconf libtool pkgconf coreutils \
        curl unzip gettext-tiny-dev git libgcc \
        go nodejs-current openjdk21 npm \
        gcc fzf ripgrep python3 py3-pip maven \
        bash clang17-extra-tools clang17 g++ \
        php83 php83-common php83-curl php83-dev php83-ffi \
        php83-fpm php83-intl php83-mbstring \
        php83-openssl php83-pdo php83-pdo_sqlite \
        php83-pdo_mysql php83-pdo_odbc php83-pdo_pgsql \
        php83-pear php83-phar php83-xml composer 

RUN go install golang.org/x/tools/gopls@latest

RUN echo -e "nameserver 8.8.8.8" > /etc/resolv.conf && \
  git clone https://github.com/neovim/neovim.git && \
  cd neovim && \
  make && \
  make install && \
  cd ../ && rm -rf neovim 

RUN git clone https://github.com/pedrohms/dotfiles && \
    mkdir /root/.config && \
    cp -Rf dotfiles/config/nvim_lazy/.config/nvim /root/.config/ && \
    rm -Rf /root/dotfiles

ENV PATH=$PATH:/root/go/bin
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk

ENTRYPOINT ["nvim"]
