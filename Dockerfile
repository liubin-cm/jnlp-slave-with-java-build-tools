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

RUN apt-get update
RUN echo 'deb http://apt.dockerproject.org/repo debian-stretch main' >> /etc/apt/sources.list
#apt-add-repository 'deb https://apt.dockerproject.org/repo debian-stretch main'
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN apt-get update
RUN apt-cache policy docker-engine
RUN apt-get install -y docker-engine=1.13.1-0~debian-stretch
RUN docker version

COPY jenkins-slave /usr/local/bin/jenkins-slave
RUN chmod +x /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]

