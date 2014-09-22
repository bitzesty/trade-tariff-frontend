FROM macool/baseimage-rbenv-docker:latest

# Install ruby and gems
RUN rbenv install 2.1.2
RUN rbenv global 2.1.2

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN gem install bundler
RUN rbenv rehash

# set $HOME
RUN echo "/root" > /etc/container_environment/HOME

# Clean up when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# let's copy and bundle frontend
ADD . /trade-tariff-frontend
RUN bundle install

# and workdir
ONBUILD WORKDIR /trade-tariff-frontend
