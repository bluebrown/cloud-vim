# Cloud VIM

IDE style VIM configuration in a docker container with built-in docker-ce and openssh-server.

![alt text](https://www.tintri.com/sites/default/files/paragraph-images/Tintri-containers-support-blog.jpg)

The purpose of this project is to provide a highly accessible IDE, with low requirements. Deploy an instance of this image, exec or ssh into it and start conding / pair coding.

It is as easy as cloning or initializing a git repo, edit some code with all the goodies of an IDE, and commit at the end of your session.


## Getting Started

* **Pull the image**
```
docker pull bluebrown/cloud-vim
```
* **run it locally** 
```
docker run -ti --name cloud-vim bluebrown/cloud-vim /bin/zsh
```
* **or start as ssh server**
```
docker run -d --name cloud-vim-ssh bluebrown/cloud-vim
```


### Prerequisites

If you want to use this image locally you need to have docker installed. Otherwise you need a cloud provider or a server with docker engine to invoke your service at all times remotely.

### No Prequisites Solution 

You can simply use something like https://labs.play-with-docker.com/ to pull the image and spin up a quick throw-away IDE without any prequisites other than a web browser with internet connection.


## Connection over ssh
Once you have an instance of this image run and started the openssh-server, you can ssh into it to code from anywhere!

### Run Example
```
docker run -d -P --name test_sshd bluebrown/cloud-vim
docker port test_sshd 22
> 0.0.0.0:49154

ssh root@localhost -p 49154 (The password is `root)
> root@test_sshd $
```
### Security
If you are making the container accessible from the internet you'll probably want to secure it bit. You can do one of the following two things after launching the container:

* Change the root password: `docker exec -ti test_sshd passwd`
* Don't allow passwords at all, use keys instead:
```
docker exec test_sshd passwd -d root
docker cp file_on_host_with_allowed_public_keys test_sshd:/root/.ssh/authorized_keys
docker exec test_sshd chown root:root /root/.ssh/authorized_keys
```

##  Docker inside Docker
This image contains Docker-CE out of the box. You can simply expose the host socket in a volume and use it from inside the running container
```
docker run -v /var/run/docker.sock /var/run/docker.sock \
           -ti --name cloud-vim bluebrown/cloud-vim /bin/zsh
```
Veyfy that you can access the socket
```
docker image ls
```

## Authors

* **Nico Braun** - *Initial work* - [bluebrown](https://github.com/bluebrown)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

