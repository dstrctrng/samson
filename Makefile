all: config/database.yml .env
	bundle check --path vendor/bundle || bundle --path vendor/bundle --local

config/database.yml:
	install -m 0600 config/database.sqlite.yml.example config/database.yml

.env:
	install -m 0600 .env.example .env
