FROM golang:1.11.1 as go-builder

RUN apt-get update -y

RUN git clone https://github.com/bluebrown/dotfiles.git  ~/.vim

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
