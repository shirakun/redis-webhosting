#!/bin/bash

install_dir="/home/user1"
redis_version="7.2.4"
bin_dir="${install_dir}/redis"
lock_file="${install_dir}/redis_install.lock"

if [ ! -d "${install_dir}" ]; then
    mkdir -p "${install_dir}"
fi


cd "${install_dir}"


if [ -f "${lock_file}" ]; then
    echo "Lock file ${lock_file} exists. Another instance may be running or a previous installation was interrupted. Exiting."
    exit 1
fi

touch "${lock_file}"

if [ -f "${install_dir}/redis/redis-server" ]; then
    echo "redis-server already exists at ${target_redis_server}. Skipping copy operation."
else

    # use git 
    # git clone https://github.com/redis/redis.git "redis-${redis_version}"
    # cd "redis-${redis_version}"
    # git checkout "${redis_version}"
    # rm -rf ./.git ./.codespell ./.github

    #use wget donwload
    wget "https://github.com/redis/redis/archive/refs/tags/${redis_version}.zip"
    unzip "${redis_version}.zip"
    rm "${redis_version}.zip"
    cd "redis-${redis_version}"

    make

    mkdir -p "${bin_dir}"
    cp src/redis-server "${bin_dir}/redis-server"
    cp src/redis-cli "${bin_dir}/redis-cli"
    cp redis.conf "${bin_dir}/redis.conf"
    wget https://github.com/shirakun/redis-webhosting/raw/master/redis.sh -O "${bin_dir}/redis.sh"

    # Use sed command for replacement
    sed -i "s/\/tmp\/redis/${bin_dir//\//\\/}/g" "${bin_dir}/redis.sh"

    chmod -R 0755 "${bin_dir}"

    cd ..
    rm -rf "redis-${redis_version}"

    echo "Redis installation completed. See log file at ${log_file} for details."

fi

rm -f "${lock_file}"

