# Docker Time Machine® Server

Yet another Docker container providing Apple®'s Time Machine® service using
Samba and Avahi (and supervisor) daemons, on a Debian 9 base.

# Usage

    $ docker build -t dehy/timemachine-server .
    $ docker run \
        -p 5353:5353/udp -p 445:445 --net host \
        -v "/opt/timemachine/data:/timemachine" \
        -v "/opt/timemachine/security:/etc/samba/security" \
        --name timemachine-server \
        dehy/timemachine-server
    $ docker exec -it timemachine-server addUser john

To delete a user

    $ docker exec -it timemachine-server delUser john

If you want to produce a non-optimized build (ie. for debug purpose),
you can pass the build arg `DEBUG=1`

    $ docker build -t dehy/timemachine-server --build-arg DEBUG=1 .

### Notes on Samba

The version used for samba is actually the master branch of the git repository.
The full support of Apple's Time Machine has only been [merged on october 4, 2017](https://git.samba.org/?p=samba.git;a=commit;h=174e6cb5e68c22cc845cb52cbebed6b43fdda1d6).
As soon as the code is available on a release, we will have to switch.

### Notes on user credentials

When you execute the `addUser [username]` command on the container, the user's 
credentials are actually stored in 2 places:
- They are referenced system-wide in the classic `/etc/passwd` file, for classic
  POSIX permissions to work. No password is saved system-wide.
- They are also referenced in the `/etc/samba/security/passdb.tdb` file. Account 
  password is stored here.

There is actually a problem: the `passdb.tdb` file is located on a docker volume,
so it could survive container redeployments but the `passwd` file is not saved
on a particulary volume, so when you redeploy the container, the system users are 
actually wiped. We need to find a way to save those users.

### Notes on security

To ensure data safety at rest, consider
[encrypting the disk](https://wiki.archlinux.org/index.php/disk_encryption#Summary) 
where backups will be stored.

### Notes on network

The container's network must be in "host" mode in order for avahi (mDNS) 
to be able to broadcast the service correctly.

#### Disclamer

I'm not, in any way, affiliated with Apple Inc. nor this project is supported by Apple Inc.

#### LICENSE

This project is under [MIT License](LICENSE)