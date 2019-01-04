# Builder image to compile go tools
FROM golang as builder

RUN go get -u -v \
  github.com/klauspost/asmfmt/cmd/asmfmt \
  github.com/derekparker/delve/cmd/dlv \
  github.com/kisielk/errcheck \
  github.com/davidrjenni/reftools/cmd/fillstruct \
  github.com/mdempsky/gocode \
  github.com/stamblerre/gocode \
  github.com/rogpeppe/godef \
  github.com/zmb3/gogetdoc \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/lint/golint \
  github.com/alecthomas/gometalinter  \
  github.com/fatih/gomodifytags \
  golang.org/x/tools/cmd/gorename \
  github.com/jstemmer/gotags \
  golang.org/x/tools/cmd/guru \
  github.com/josharian/impl \
  honnef.co/go/tools/cmd/keyify \
  github.com/fatih/motion \
  github.com/koron/iferr

# The Actual Image
FROM golang
COPY --from=builder /go/bin /go/bin/

# Set language enviroment, requierd for tmux
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Enable advanced colors and italic fonts
COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

# Install Tools
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    apt update && apt install -y \
      task \
      zsh \
      tmux \
      vim-nox \
      openssh-server

# Install docker depenencies
RUN apt-get install -y  \
  apt-transport-https \
  ca-certificates gnupg2 \
  software-properties-common

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository -y \
      "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable""" && \
    apt update && apt install -y docker-ce

# Install docker-compose


# Fetch and source configuration
RUN git clone https://github.com/bluebrown/dotfiles.git  ~/dotfiles && \
    /bin/bash -c "source ~/dotfiles/fiddle.script"

# Set the workdir to quick pull go repos
WORKDIR /go/src/github.com/bluebrown/

# Expose port
EXPOSE 22

