FROM ubuntu:15.04

MAINTAINER dockstore.org

RUN  apt-get update \
  && apt-get install -y samtools

