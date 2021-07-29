create-vagrant-ssh:
	vagrant ssh-config > vagrant-ssh
	ssh -F vagrant-ssh default

tunnel-avni-prod-read:
	ssh avni-server-prod -L 2203:serverdb.read.openchs.org:5432

get-schema-def:
	pg_dump --host localhost --port 2203 --username openchs --schema-only --verbose --file /tmp/avni-schema.sql openchs

create-db:
	sudo -u postgres psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'openchs' AND pid <> pg_backend_pid()"
	-sudo -u postgres psql -c "create user openchs with password 'password'"
	-sudo -u postgres psql -c 'drop database openchs'
	sudo -u postgres psql -c 'create database openchs with owner openchs'
	sudo -u postgres psql -c 'create extension if not exists "uuid-ossp"'
	sudo -u postgres psql openchs -f '/tmp/avni-schema.sql'
#	sh database/export-tables.sh $(orgId)

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
