# Cloud VIM

IDE style VIM configuration in a docker container with built-in docker engine and ssh server.

## Getting Started
You can pull the image or clone the repo
```
docker pull bluebrown/cloud-vim
git clone https://github.com/bluebrown/cloud-vim.git
```

### Prerequisites

If you want to use this image locally you need to have docker installed. Otherwise you need a cloud provider or a server with docker engine to invoke your service at all times remotely.

### No Prequisites Solution 

You can simply use something like https://labs.play-with-docker.com/ to pull the image and spin up a quick throw-away IDE without any prequisites other than a web browser with internet connection.

```
docker pull bluebrown/cloud-vim
docker run -ti bluebrown/cloud-vim /bin/zsh
```

## Development
To build this image youself with own configurations pull this repo
```
git clone https://github.com/bluebrown/cloud-vim.git
```
Within the dockerfile is a repository url specified which points to a collection of dotfiles.
You might fork and change these and update the url in the dockerfile https://github.com/bluebrown/dotfiles

```
git clone https://github.com/<yourname>/dotfiles.git
```
After changing the files to your need you can build you own image
```
docker build -t <yourname>/cloud-vim .
```

## Authors

* **Nico Braun** - *Initial work* - [bluebrown](https://github.com/bluebrown)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

