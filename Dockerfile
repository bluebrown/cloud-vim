FROM golang:1.11.1 as builder

# Set language enviroment, requierd for tmux
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install Tools
RUN apt update -y && apt install task zsh tmux vim-nox openssh-server -y && \
     curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install go-tools required for vim-go
RUN go get -u -v github.com/klauspost/asmfmt/cmd/asmfmt && \
    go get -u -v github.com/derekparker/delve/cmd/dlv && \
    go get -u -v github.com/kisielk/errcheck && \
    go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct && \
    go get -u -v github.com/mdempsky/gocode && \
    go get -u -v github.com/stamblerre/gocode && \
    go get -u -v github.com/rogpeppe/godef && \
    go get -u -v github.com/zmb3/gogetdoc && \
    go get -u -v golang.org/x/tools/cmd/goimports && \
    go get -u -v golang.org/x/lint/golint && \
    go get -u -v github.com/alecthomas/gometalinter && \
    go get -u -v github.com/fatih/gomodifytags && \
    go get -u -v golang.org/x/tools/cmd/gorename && \
    go get -u -v github.com/jstemmer/gotags && \
    go get -u -v golang.org/x/tools/cmd/guru && \
    go get -u -v github.com/josharian/impl && \
    go get -u -v honnef.co/go/tools/cmd/keyify && \
    go get -u -v github.com/fatih/motion && \
    go get -u -v github.com/koron/iferr

# Fetch and source dotfiles
RUN git clone https://github.com/bluebrown/dotfiles.git  ~/dotfiles && \
    /bin/bash -c "source ~/dotfiles/fiddle.script"

# Enable advanced colors and italic fonts
COPY xterm-256color-italic.terminfo /root
RUN tic /root/xterm-256color-italic.terminfo
ENV TERM=xterm-256color-italic

# Expose port
EXPOSE 22
