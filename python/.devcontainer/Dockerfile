FROM python:buster

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget \
    && apt-get -y install libqt5printsupport5

RUN wget https://github.com/MiniZinc/MiniZincIDE/releases/download/2.6.2/MiniZincIDE-2.6.2-bundle-linux-x86_64.tgz \
    && tar xf MiniZincIDE-2.6.2-bundle-linux-x86_64.tgz \
    && rm MiniZincIDE-2.6.2-bundle-linux-x86_64.tgz

ENV PATH="./MiniZincIDE-2.6.2-bundle-linux-x86_64/bin:${PATH}"


