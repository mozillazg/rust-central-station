FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      g++ \
      curl \
      ca-certificates \
      libc6-dev \
      make \
      libssl-dev \
      pkg-config \
      python3-venv \
      python3-pip \
      python3-setuptools \
      git \
      rsyslog \
      nginx \
      letsencrypt \
      cron \
      ssh \
      gnupg \
      cmake \
      logrotate \
      file \
      ssmtp \
      locales

# Set the system locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Rust and Cargo
RUN curl https://sh.rustup.rs |sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin


# Install homu, our integration daemon
RUN git clone https://github.com/servo/homu /homu
RUN cd /homu && git reset --hard 39c40e0bccb12652ad7fe6f6637c37105625b072
RUN pip3 install -e /homu

# Install local programs used:
#
# * tq - a command line 'toml query' program, used to extract data from
#        secrets.toml
# * rbars - a command line program to run a handlebars file through a toml
#           configuration, in our case used to expand templates using the values
#           in secrets.toml
# * promote-release - cron job to download artifacts from travis/appveyor
#                     archives and publish them (also generate manifests)
COPY tq /tmp/tq
RUN cargo install --path /tmp/tq && rm -rf /tmp/tq
COPY rbars /tmp/rbars
RUN cargo install --path /tmp/rbars && rm -rf /tmp/rbars


# Initialize our known set of ssh hosts so git doesn't prompt us later.
RUN mkdir /root/.ssh && ssh-keyscan github.com >> /root/.ssh/known_hosts

# Copy the source directory into the image so we can run scripts and template
# configs from there
COPY . /src/

CMD ["/src/bin/run.sh"]
