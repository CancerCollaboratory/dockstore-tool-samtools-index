FROM ubuntu:15.04

RUN  apt-get update \
  && apt-get install -y samtools

