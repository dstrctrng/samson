BUNDLED := $(shell bin/is-bundled)

all: $(BUNDLED)
	@true

deploy:
	bin/test-this

bootstrap: config/database.yml .env

config/database.yml: $(BUNDLED)
	install -m 0600 config/database.sqlite.yml.example config/database.yml
	@echo Might want to run: bundle exec rake db:setup

.env: $(BUNDLED)
	bundle exec rake secret | bin/embed-secret.pl - .env.example > .env.tmp
	install -m 0600 .env.tmp .env
	rm -f .env.tmp

need_bundler:
	echo $(BUNDLED)
	bundle check --path vendor/bundle 2>&-|| bundle --path vendor/bundle --local
	touch .already_bundled

.already_bundled:
	touch .already_bundled

sleep:
	sleep 88888 &
	sleep 88888 &
	sleep 88888 &
	sleep 88888 &
	sleep 88888
