FROM ruby:3.1.2-alpine AS builder
ENV RAILS_ENV=production
WORKDIR /app
RUN apk add tzdata build-base nodejs postgresql-dev
COPY Gemfile* .
RUN bundle install
COPY . .
# If there are encrypted credentials, rename them before and after to avoid a MissingKeyError
ONBUILD RUN mv config/credentials.yml.enc config/credentials.yml.enc.bak 2>/dev/null || true
ONBUILD RUN RAILS_ENV=production \
            SECRET_KEY_BASE=dummy \
            RAILS_MASTER_KEY=dummy \
            bundle exec rails assets:precompile
ONBUILD RUN mv config/credentials.yml.enc.bak config/credentials.yml.enc 2>/dev/null || true
FROM ruby:3.1.2-alpine AS runner
ENV RAILS_ENV=production
WORKDIR /app
RUN apk add tzdata postgresql-dev
# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY . .
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/public/assets/ /app/public/assets/

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
