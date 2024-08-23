FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV IN_DOCKER=1

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get update && apt-get install -y --no-install-recommends sudo locales

# Set the locale - This fixes some cursor issues in zsh
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8     

# NOTE: This container isn't actually intentended to be used anywhere,
# so the password doesn't matter
RUN adduser matt && chpasswd matt:password
RUN echo "matt ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

COPY --chown=matt . /home/matt/dotfiles

USER matt

WORKDIR /home/matt/dotfiles

# RUN ./install.sh
