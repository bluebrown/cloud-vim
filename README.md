# Cloud VIM

IDE style VIM configuration in a docker container with built-in docker engine and ssh server.

![alt text](https://www.tintri.com/sites/default/files/paragraph-images/Tintri-containers-support-blog.jpg)

The purpose of this project is to provide a high customable IDE with low requirements. It can be used in different context, to enable quick coding sessions no matter where you are. 
For example one could deploy this image on a personal server/cluster and then use the pre configured ssh server, to start a remote session or pair coding. A web frontend solution is also possible.
Anohter use case could be, to pull this image locally and use it as IDE, without installing one locally.
Sometimes it can also be usefull to pull this image into a playground, in the web. 

It is as easy as spinning a container up, ssh into it, clone a git repo, edit some code and commit. Afterwards the whole container can get thrown away as the code persists in your repository.


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

