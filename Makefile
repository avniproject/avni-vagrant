create-vagrant-ssh:
	vagrant ssh-config > vagrant-ssh
	ssh -F vagrant-ssh default

tunnel-avni-prod-read:
	ssh avni-server-prod -L 2203:serverdb.read.openchs.org:5432

get-schema-def:
	pg_dump --host localhost --port 2203 --username openchs --schema-only --verbose --file /tmp/avni-schema.sql openchs

export-table:
	#psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM concept limit 100) TO STDOUT;" openchs
	sh database/export-tables.sh $(orgId)
