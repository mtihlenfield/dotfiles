FROM ubuntu:20.04 AS dotfiles-base

ENV DEBIAN_FRONTEND=noninteractive
ENV IN_DOCKER=1
ENV DFUSER=dfuser

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
# sudo and vim for debugging, locales for setting the correct locale
RUN apt-get update && apt-get install -y --no-install-recommends sudo locales vim

# Set the locale - This fixes some cursor issues in zsh
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8     
RUN dpkg-reconfigure locales

# NOTE: This container isn't actually intended to be used anywhere,
# so the password doesn't matter
RUN adduser "$DFUSER" && chpasswd "$DFUSER":password
RUN echo "$DFUSER ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

USER "$DFUSER"
WORKDIR /home/"$DFUSER"/

FROM dotfiles-base AS dotfiles

COPY --chown="$DFUSER" . /home/"$DFUSER"/dotfiles

WORKDIR /home/"$DFUSER"/dotfiles

RUN ./install.sh

FROM dotfiles-base AS dotfiles-offline-test

ADD --chown="$DFUSER" dotfiles.tar.gz  /home/"$DFUSER"

WORKDIR "/home/$DFUSER/dotfiles"

RUN ./install.sh unpack
