FROM golang:1.11.1 as builder

# Dependencies
RUN apt update -y && apt install task vim-nox openssh-server -y && \
     curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Go Tools
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

# Cofiguration
RUN git clone https://github.com/bluebrown/dotfiles.git  ~/dotfiles && \
    echo "source ~/dotfiles/bashrc" >> ~/.bashrc && \
    echo "source ~/.bashrc" >> ~/.bash_profile && \
    echo "source ~/dotfiles/vimrc" >> ~/.vim/vimrc

EXPOSE 22
