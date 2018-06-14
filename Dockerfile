From docker.io/jenkinsci/jnlp-slave

USER root

RUN dpkg --add-architecture i386
RUN apt-get update 
RUN apt-get install -y \
    tar zip unzip \
    wget curl \
    git \
    build-essential \
    python python-pip less \
    libnotify-bin ssh \
    libncurses5:i386 libstdc++6:i386 zlib1g:i386


ENV MAVEN_VERSION 3.3.9

RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

    # Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean
#====================================
# Kubernetes CLI
# See http://kubernetes.io/v1.0/docs/getting-started-guides/aws/kubectl.html
#====================================
RUN curl https://storage.googleapis.com/kubernetes-release/release/v1.10.3/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_VERSION 1.13.1
ENV DOCKER_SHA256 4a9766d99c6818b2d54dc302db3c9f7b352ad0a80a2dc179ec164a3ba29c2d3e

RUN curl -fsSL 'https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e' | apt-key add -
RUN apt-get update && add-apt-repository \
   "deb https://packages.docker.com/1.13/apt/repo/ \
   ubuntu-$(lsb_release -cs) \
   main"
RUN apt-get install -y docker-engine=1.13.1
RUN docker version

COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod +x /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]

