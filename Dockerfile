FROM ubuntu:latest AS base

FROM base AS final
RUN apt update && \
  apt install -y git curl diffutils sudo

ARG USERNAME=user
ARG UID=1500
ARG GROUPNAME=user
ARG GID=1500
ARG PASSWORD=password
RUN groupadd -g $GID $GROUPNAME \
  && useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME \
  && echo $USERNAME:$PASSWORD | chpasswd \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user/

COPY --chown=user:group --chmod=755 ./ /home/user/.dotfiles

CMD [ "/home/user/.dotfiles/scripts/install.sh" ]
