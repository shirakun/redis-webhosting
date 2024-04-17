# About
Most webhosting do not provide redis.
The purpose of this script is to compile and run redis in webhosting.

[![Support Ukraine Badge](https://bit.ly/support-ukraine-now)](https://github.com/support-ukraine/support-ukraine)

## Note
Not all webhosts can compile redis.

It has been tested and runs on the following webhosting

|Hosting|Panel Type|Redis Version|Result|Url|
|-|-|-|-|-|
|Namecrane(Buyvm)|Cpanel|7.2.0|pass|https://namecrane.com/|
|Myw|DirectAdmin|7.2.0|pass|https://myw.pt/|
|Xrea|Self developed|7.2.4|pass|https://www.xrea.com/|
|JustHost|DirectAdmin|7.2.4|pass|https://justhost.ru|

Running redis this way may violate webhosting's tos!

# Usage

When building, it will take up some disk space.
When using this script, please make sure that your webhosting has more than 500M (this data is from redis 7.2.0,new version may require more) of free space.

Let's say that your web hosting path is `/home/user1`

## Download and edit script

Download `build.sh`

Modify the version number and file path in the file
```
install_dir="/home/user1"
redis_version="7.2.0"
```
Upload it to `/home/user1/build.sh`

## Run script

If you have ssh access, then you just need to run `bash build.sh` in ssh.

If you don't have ssh access, then you need to trigger the run via crontab, add the command `bash /home/user1/build.sh >> /home/user1/output.txt > 2>&1` to crontab with an interval of every minute.

The file `redis_install.lock` will appear in the directory after crontab is executed, and will be deleted automatically after build.

You can verify that redis was compiled successfully by checking the contents of output.txt.

Then delete crontab.

## edit redis config

Open redis.conf and make the following changes to it

 - Find `bind`, and change it(The address should be one of 127.0.0.0/8 and avoid 127.0.0.1)
 - Find `port` and change it to any other high level port, e.g. `11451`.
 - Find `protected-mode` and change it to `no` (you don't need to change it if you set auth, but we don't set auth in this article for convenience).
 - Find `dir` and change its path to `/home/user1/redis`.
 -find `pidfile` and change it to `/home/user1/redis/redis.pid`

## Run redis

Add the command `bash /home/user1/redis/redis.sh` to the crontab and set it to run every minute.

# Note

 - The performance of redis depends on the limitations that webhosting puts on you (memory/io/cpu etc.)
 - The redis process may be killed at any time until redis.sh is executed again.

 
