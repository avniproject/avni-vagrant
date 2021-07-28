create-vagrant-ssh:
	vagrant ssh-config > vagrant-ssh
	ssh -F vagrant-ssh default

tunnel-avni-prod-read:
	ssh avni-server-prod -L 2203:serverdb.read.openchs.org:5432
