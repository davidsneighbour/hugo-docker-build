FROM fedora:35 AS base

RUN dnf -y update && dnf -y install gcc git golang nodejs python3-devel python3-pip python-wheel-wheel

WORKDIR "/app"

COPY requirements.txt requirements.txt
COPY package.json package.json

RUN ["/usr/bin/pip3", "install", "--target=python_modules", "--requirement=requirements.txt"]
RUN ["/usr/bin/npm", "install"]
RUN ["/usr/bin/git", "clone", "--depth", "1", "--branch", "v0.95.0", "https://github.com/gohugoio/hugo.git"]
WORKDIR "/app/hugo"
ENV CGO_ENABLED="1"
RUN ["/usr/bin/go", "version"]
RUN ["curl", "-LO", "https://go.dev/dl/go1.18.linux-amd64.tar.gz"]
RUN ["sudo", "tar", "-C", "/usr/local", "-xzf", "go1.18.linux-amd64.tar.gz"]
RUN ["export", "GOROOT=/usr/local/go"]
RUN ["export", "GOPATH=$HOME/go"]
RUN ["export", "PATH=$GOPATH/bin:$GOROOT/bin:$PATH"]
RUN ["/usr/bin/go", "version"]
RUN ["/usr/bin/go", "mod", "download", "github.com/yuin/goldmark"]
RUN ["/usr/bin/go", "build", "-v", "--tags", "extended"]
