# jnlp-slave-with-java-build-tools
From docker.io/cloudbees/jnlp-slave-with-java-build-tools:2.0.0
USER root
RUN apt-get update
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
RUN apt-get update
RUN apt-cache policy docker-engine
RUN apt-get install -y docker-engine=1.12.6-0~ubuntu-xenial
RUN usermod -aG docker jenkins
USER jenkins
