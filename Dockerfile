FROM macool/baseimage-rbenv-docker:latest

# Update rbenv and ruby-build definitions
RUN bash -c 'cd /root/.rbenv && git pull'
RUN bash -c 'cd /root/.rbenv/plugins/ruby-build && git pull'

# Install ruby and gems
RUN rbenv install 2.1.4
RUN rbenv global 2.1.4

RUN echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

RUN gem install bundler
RUN rbenv rehash

# set $HOME
RUN echo "/root" > /etc/container_environment/HOME

# let's copy and bundle frontend
ADD . /trade-tariff-frontend
# and workdir
WORKDIR /trade-tariff-frontend
RUN bundle install

# script that will update backend's IP
RUN mkdir -p /etc/my_init.d
ADD backend_ip.sh /etc/my_init.d/backend_ip.sh
RUN chmod +x /etc/my_init.d/backend_ip.sh
