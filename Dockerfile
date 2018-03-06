FROM kjbreil/lgsm

LABEL maintainer="Kjell Breiland <kjell.breiland@gmail.com>"

ENV TERM xterm

RUN bash linuxgsm.sh pzserver && \
  /home/server/pzserver update-lgsm && \
  /home/server/pzserver auto-install && \
  /home/server/pzserver update

EXPOSE 28015/tcp 28015/udp 28016/tcp 28016/udp

COPY entrypoint.sh entrypoint.sh

VOLUME ["/home/server/log", "/home/server/Zomboid/Server/"]

ENTRYPOINT ["bash", "entrypoint.sh"]

CMD ["start"]
