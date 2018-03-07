FROM kjbreil/lgsm

LABEL maintainer="Kjell Breiland <kjell.breiland@gmail.com>"

ENV TERM xterm

ENV IP "0.0.0.0"
ENV ADMIN_PASSWORD "iamstupid"
ENV SERVER_NAME "pz-server"

RUN bash linuxgsm.sh pzserver && \
  /home/server/pzserver update-lgsm && \
  /home/server/pzserver auto-install && \
  /home/server/pzserver update

EXPOSE 8766/udp 8767/udp 27015/tcp 16261/udp 16261/tcp 16262-16272/tcp

COPY entrypoint.sh entrypoint.sh

VOLUME ["/home/server/log", "/home/server/Zomboid/Server/"]

ENTRYPOINT ["bash", "entrypoint.sh"]

CMD ["start"]
