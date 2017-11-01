FROM debian:9

ARG DEBUG

EXPOSE 5353/udp 445
VOLUME /timemachine
VOLUME /etc/samba/security

COPY docker/build.sh /build.sh
RUN bash /build.sh && bash -c "[ "${DEBUG:-0}" == "0" ] && rm -rf /build || exit 0"

COPY docker/config/ /etc/
COPY bin/ /usr/local/bin/

RUN chmod +x /usr/local/bin/addUser /usr/local/bin/delUser

ENTRYPOINT supervisord -n -c /etc/supervisor/supervisord.conf