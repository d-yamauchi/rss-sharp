FROM ruby:2.6.1

# RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get update -qq
RUN apt-get install -y build-essential
RUN apt-get install -y libpq-dev
RUN apt-get install -y nodejs
RUN apt-get install -y cron

WORKDIR /Users/d-yamauchi/Documents/apps/rss-sharp

# gemfileを追加する
ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock

# gemfileのinstall
RUN bundle install
ADD . .
