FROM ruby:3.1.2

EXPOSE 18009
WORKDIR /build
COPY .ruby-gemset .
COPY .ruby-version .
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

WORKDIR /app

ENTRYPOINT ["jekyll"]
CMD ["serve", "--port", "19040", "--host", "0.0.0.0", "--watch", "--livereload", "--drafts", "--future"]
