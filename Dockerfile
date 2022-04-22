FROM ruby:2.7.2
RUN usermod -a -G sudo root
RUN gem install bundler -v '2.1.4'
RUN apt-get update -qq \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    bash \
    sudo \
    nano \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /code
WORKDIR /code
COPY Gemfile /code/Gemfile
COPY Gemfile.lock /code/Gemfile.lock
RUN bundle install
COPY . /code

RUN sed -i ~/.profile -e 's/mesg n || true/tty -s \&\& mesg n/g'

RUN chmod +x scripts/*.sh
