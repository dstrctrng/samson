BUNDLED := $(shell script/is-bundled)

all: config/database.yml .env

config/database.yml: $(BUNDLED)
	install -m 0600 config/database.sqlite.yml.example config/database.yml
	bundle exec rake db:setup

.env: $(BUNDLED)
	bundle exec rake secret | script/embed-secret.pl - .env.example > .env.tmp
	install -m 0600 .env.tmp .env
	rm -f .env.tmp

need_bundler:
	echo $(BUNDLED)
	bundle check --path vendor/bundle || bundle --path vendor/bundle --local
	touch .already_bundled

.already_bundled:
	touch .already_bundled
