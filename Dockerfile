FROM ruby:2.5

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev ghostscript
RUN apt-get install git
RUN apt-get install -y python3 python3-pip
RUN apt-get install imagemagick
RUN python3 -m pip install pillow

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
RUN gem install hanami
EXPOSE 2300

# Configure the main process to run when running the image
CMD ["hanami", "server"]
