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

# Copy the compiled go tools from the builder image
# Vim-Go  dependencies
COPY --from=builder /go/bin /go/bin/

# Docker dependencies
RUN apt update &&  apt install -y  \
      apt-transport-https \
      ca-certificates gnupg2 \
      software-properties-common && \
      curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository -y \
      "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"""

# Install Core Tools
RUN apt update && apt install -y \
      docker-ce \
      golang-glide \
      openssh-server \
      task \
      tmux \
      vim-nox \
      zsh

# Setup zsh & install plugins
RUN chsh -s /usr/bin/zsh && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Setup Vim with Vim Plug & install plugins
COPY ./dotfiles/vimrc /root/.vim/vimrc
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    vim -c 'PlugInstall --sync' -c 'qa!' && rm /root/.vim/vimrc

# Copy the configuration files
# Remember to check for updates in git submodule
COPY ./dotfiles /root/dotfiles
RUN /bin/bash -c "source ~/dotfiles/fiddle.sh" && \
    mv ~/dotfiles/gitconfig ~/.gitconfig && \
    mv ~/dotfiles/xterm-256color-italic.terminfo ~/xterm-256color-itlaic.terminfo && \
    tic ~/xterm-256color-italic.terminfo

# Set environment variables
ENV \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \
  TERM=xterm-256color-italic \
  NAME=nicobraun \
  USER=bluebrown \
  EMAIL=nico-braun@live.de \
  TASKRC=~/dotfiles/taskrc

RUN git config --global user.name $NAME && \
    git config --global user.mail $EMAIL && \
    git config --global user.username $USER

# Workdir for go projects
WORKDIR /go/src/github.com/$USER/
CMD ["zsh"]

