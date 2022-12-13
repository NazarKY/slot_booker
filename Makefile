run:
	./bin/dev

setup:
	bundle install
	npm install
	rake db:create db:migrate db:seed

test:
	rspec spec

drop:
	rails db:drop --trace
