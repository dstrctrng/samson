BUNDLE := bundler_$(shell bundle check 2>&- | awk '{print $NF}')

all: config/database.yml .env

config/database.yml: $(BUNDLED)
	install -m 0600 config/database.sqlite.yml.example config/database.yml
	bundle exec rake db:setup

.env: $(BUNDLED)
	bundle exec rake secret | script/embed-secret.pl - .env.example > .env.tmp
	install -m 0600 .env.tmp .env
	rm -f .env.tmp

bundler_:
	bundle check --path vendor/bundle || bundle --path vendor/bundle --local

bundler_satisfied:
	@true
