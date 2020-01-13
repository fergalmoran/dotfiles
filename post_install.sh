#!/usr/bin/env sh

# docker-completion
sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.0/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/machine/v0.16.0/contrib/completion/bash/docker-machine.bash -o /etc/bash_completion.d/docker-machine
sudo curl https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker -o /etc/bash_completion.d/docker

# copy kubernetes file
cp pi@cluster-master:/home/pi/.kube/config /home/fergalm/.kube/config
