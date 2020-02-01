FROM ruby:2.7.0-alpine3.11 AS pre-builder

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

RUN apk add --update --no-cache \
    build-base

RUN gem install fastlane -NV \
 && rm -rf /usr/local/bundle/cache/*.gem

FROM diogo0liveira/android-29-alpine-slim:1.0.0
LABEL maintainer="Diogo Oliveira <diogo0liveira@hotmail.com>"

ENV LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en' \
    LC_ALL='en_US.UTF-8'

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

COPY --from=pre-builder /root/.gem /root/.gem
COPY --from=pre-builder /usr/local /usr/local

RUN apk add --update --no-cache \
 ruby \
 ruby-bundler \
 coreutils \
 && rm -rf /tmp/* \
 && rm -rf /var/cache/apk/* \
 && rm -rf /usr/local/bundle/cache/*.gem 

CMD ["/bin/sh"]