MANAGE=./manage.py
APP=mediathread
FLAKE8=./ve/bin/flake8

jenkins: ./ve/bin/python check jshint jscs flake8 test

./ve/bin/python: requirements.txt bootstrap.py virtualenv.py
	./bootstrap.py

jshint: node_modules/jshint/bin/jshint
	./node_modules/jshint/bin/jshint media/js/app/

jscs: node_modules/jscs/bin/jscs
	./node_modules/jscs/bin/jscs media/js/app/

node_modules/jshint/bin/jshint:
	npm install jshint --prefix .

node_modules/jscs/bin/jscs:
	npm install jscs@1.8.1 --prefix .

test: ./ve/bin/python
	$(MANAGE) jenkins --pep8-exclude=migrations --enable-coverage --coverage-rcfile=.coveragerc

harvest1: ./ve/bin/python
	$(MANAGE) harvest --settings=mediathread.settings_test --failfast -v 4 mediathread/main/features
	$(MANAGE) harvest --settings=mediathread.settings_test --failfast -v 4 mediathread/assetmgr/features
    $(MANAGE) harvest --settings=mediathread.settings_test --failfast -v 4 mediathread/taxonomy/features

harvest2: ./ve/bin/python
	$(MANAGE) harvest --settings=mediathread.settings_test --failfast -v 4 mediathread/projects/features

flake8: ./ve/bin/python
	$(FLAKE8) $(APP) --max-complexity=8
	$(FLAKE8) structuredcollaboration --max-complexity=8

runserver: ./ve/bin/python check
	$(MANAGE) runserver

migrate: ./ve/bin/python check jenkins
	$(MANAGE) migrate

check: ./ve/bin/python
	$(MANAGE) check

shell: ./ve/bin/python
	$(MANAGE) shell_plus

clean:
	rm -rf ve
	rm -rf media/CACHE
	rm -rf reports
	rm -f celerybeat-schedule
	rm -rf .coverage
	find . -name '*.pyc' -exec rm {} \;

pull:
	git pull
	make check
	make test
	make migrate
	make flake8

rebase:
	git pull --rebase
	make check
	make test
	make migrate
	make flake8

# run this one the very first time you check
# this out on a new machine to set up dev
# database, etc. You probably *DON'T* want
# to run it after that, though.
install: ./ve/bin/python check jenkins
	createdb $(APP)
	$(MANAGE) syncdb --noinput
	make migrate
