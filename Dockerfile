FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV IN_DOCKER=1

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt update
RUN apt install -y sudo

RUN adduser user
RUN chpasswd user:password
RUN echo "user ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

ADD dotfiles.tar.gz /home/user

USER user

WORKDIR /home/user

RUN cd dotfiles && ./install.sh
