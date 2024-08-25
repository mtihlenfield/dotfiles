FROM ubuntu:20.04 AS dotfiles-base

ENV DEBIAN_FRONTEND=noninteractive
ENV IN_DOCKER=1
ENV DFUSER=dfuser

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update && apt-get install -y --no-install-recommends sudo locales

# Set the locale - This fixes some cursor issues in zsh
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8     
RUN dpkg-reconfigure locales

# NOTE: This container isn't actually intennded to be used anywhere,
# so the password doesn't matter
RUN adduser "$DFUSER" && chpasswd "$DFUSER":password
RUN echo "$DFUSER ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

COPY --chown="$DFUSER" . /home/"$DFUSER"/dotfiles

USER "$DFUSER"

WORKDIR /home/"$DFUSER"/dotfiles

FROM dotfiles-base AS dotfiles

RUN ./install.sh
