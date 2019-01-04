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
# Required for vim go
COPY --from=builder /go/bin /go/bin/

# Set language enviroment, requierd for tmux
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Enable advanced colors and italic fonts
COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

# Install docker depenencies & docker
RUN apt update &&  apt install -y  \
  apt-transport-https \
  ca-certificates gnupg2 \
  software-properties-common

# Install docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository -y \
      "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable""" && \
    apt update && apt install -y docker-ce


# Install common tools
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
     apt install -y \
      task \
      zsh \
      tmux \
      vim-nox \
      openssh-server

# Set up custom configuration for zsh
RUN chsh -s /usr/bin/zsh && \
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Fetch and source personal dotfiles
RUN git clone https://github.com/bluebrown/dotfiles.git  ~/dotfiles && \
    /bin/bash -c "source ~/dotfiles/fiddle.sh"

# Set the workdir to quick pull go repos
WORKDIR /go/src/github.com/bluebrown/

# Expose port
EXPOSE 22

