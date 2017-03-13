#!/usr/bin/env bash

readonly CWD=$(pwd)

cd ~/bin

if [ ! -f ocular ]; then
	curl -L -o ocular -s https://scrutinizer-ci.com/ocular.phar
fi

if [ ! -d test-reporter ]; then
	curl -L -o test-reporter.tar.gz -s https://github.com/codeclimate/php-test-reporter/archive/v0.4.4.tar.gz
	mkdir -p test-reporter-src
	tar -zxf test-reporter.tar.gz -C test-reporter-src --strip-components=1
	cd test-reporter-src
	composer install --no-dev --prefer-dist --quiet
	cd ..
	ln -s test-reporter ~/bin/test-reporter-src/composer/bin/test-reporter
fi

if [ ! -f coveralls ]; then
	curl -L -o coveralls -s https://github.com/satooshi/php-coveralls/releases/download/v1.0.1/coveralls.phar
fi

cd "${CWD}"

php ocular code-coverage:upload --format=php-clover build/logs/clover.xml
php test-reporter --no-interaction
php coveralls.phar --no-interaction
