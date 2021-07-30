create-vagrant-ssh:
	vagrant ssh-config > vagrant-ssh
	ssh -F vagrant-ssh default

tunnel-avni-prod-read:
	ssh avni-server-prod -L 2203:serverdb.read.openchs.org:5432

dump-org:
ifndef dbUser
	@echo "Please specify dbUser for the organisation"
	exit 1
endif
	pg_dump --host localhost --port 2203 --username $(dbUser) --file /tmp/avni-dump.sql -T account --exclude-table-data=individual --exclude-table-data=audit --exclude-table-data=individual_relationship --exclude-table-data=individual_relationship_type --exclude-table-data=program_encounter --exclude-table-data=program_enrolment --exclude-table-data=encounter --exclude-table-data=checklist_detail --exclude-table-data=checklist_item_detail --enable-row-security openchs

export-import-tables:
ifndef dbUser
	@echo "Please specify dbUser for the organisation"
	exit 1
endif
	sh database/export-import-tables.sh $(dbUser)

create-db:
ifndef dbUser
	@echo "Please specify dbUser for the organisation"
	exit 1
endif
	sudo -u postgres psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'openchs' AND pid <> pg_backend_pid()"
	-sudo -u postgres psql -c 'drop database openchs'
	-sudo -u postgres psql -c 'drop role openchs'
	-sudo -u postgres psql -c 'drop role $(dbUser)'
	-sudo -u postgres psql -c "create user openchs with password 'password' createrole"
	sudo -u postgres psql -c 'create database openchs with owner openchs'
	sudo -u postgres psql -d openchs -c 'create extension if not exists "uuid-ossp"'
	sudo -u postgres psql -d openchs -c 'create extension if not exists "ltree"'
	sudo -u postgres psql -d openchs -c 'create extension if not exists "hstore"'
	sudo -u postgres psql -d openchs -c "create role $(dbUser) noinherit login password 'password'"
	sudo -u postgres psql -d openchs -c "grant $(dbUser) to openchs"

import-dump:
	sudo -u postgres psql openchs -f '/tmp/avni-dump.sql'

create-db-full: create-db import-dump export-import-tables

#individual
#individual_relationship
#individual_relationship_type
#program_encounter
#program_enrolment
#encounter
#checklist_detail
#checklist_item_detail
#comment
#comment_thread
