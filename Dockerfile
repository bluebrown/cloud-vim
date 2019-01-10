# Builder image to compile go tools
FROM golang as builder

# Get and compile the go tools
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

# Vim-Go  dependencies
COPY --from=builder /go/bin /go/bin/

# Docker dependecies
RUN apt-get update &&  apt-get install -y --no-install-recommends  \
      apt-transport-https \
      ca-certificates gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository -y \
      "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"""

# Tools
RUN apt-get update && apt-get install -y --no-install-recommends \
      docker-ce \
      golang-glide \
      openssh-server \
      task \
      tmux \
      tree \
      vim-nox \
      zsh

# Install zsh plugins
RUN chsh -s /usr/bin/zsh && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Install vim plugins
COPY ./dotfiles/vimrc /root/.vim/
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    vim -c 'PlugInstall --sync' -c 'qa!' && rm /root/.vim/vimrc

# Configure ssh server
RUN mkdir /var/run/sshd && \
    echo 'root:root' | chpasswd && \
    sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    mkdir /root/.ssh

# Set enviroment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Europe/Madrid \
    TERM=xterm-256color \
    TASKRC=~/dotfiles/taskrc

# Expost tcp port for ssh
EXPOSE 22

# Get the dotfiles
COPY ./dotfiles /root/dotfiles

RUN /bin/bash -c "/root/dotfiles/fiddle.sh -ztvwg -n bluebrown -m nico-braun@live.de"

# Start sshd by default
# CMD ["/usr/sbin/sshd", "-D"]


