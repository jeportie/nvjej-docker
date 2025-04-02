# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    install.dockerfile                                 :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jeportie <jeportie@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/16 14:06:12 by jeportie          #+#    #+#              #
#    Updated: 2025/04/02 19:19:51 by jeportie         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# **************************************************************************** #
# All Dependencies needed to be intalled on the Docker.
# **************************************************************************** #

# Combined APT installation
apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    make \
    git \
    bear \
    tree \
    ripgrep \
    curl \
    wget \
    npm \
    expect \
    unzip \
    tar \
    p7zip-full \
    zsh \
    libreadline-dev \
    valgrind \
    check \
    lldb \
    libxext-dev \
    libx11-dev \
    libbsd-dev \
    x11-apps \
    xclip \
    python3-pip \
    python3-venv \
    libgtest-dev \
    lua5.3 \
    lua5.3-dev \
    lua5.1 \
    lua5.1-dev && \
    rm -rf /var/lib/apt/lists/*

# Minilibx Installation
git clone https://github.com/42Paris/minilibx-linux.git /opt/minilibx
cd /opt/minilibx
make
cd -

# Google Test Build and Installation
cd /usr/src/gtest
cmake .
make
cp lib/*.a /usr/lib/
ldconfig
cd -

# LuaRocks and Lua Modules Installation
wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz
tar zxpf luarocks-3.11.1.tar.gz
cd luarocks-3.11.1
./configure
make
make install
luarocks install luasocket
luarocks install busted
luarocks --lua-version=5.1 install vusted
cd ..
rm -rf luarocks-3.11.1 luarocks-3.11.1.tar.gz
