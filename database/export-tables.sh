for TABLE in $(cat ./database/non-tx-tables-with-org-id.txt)
	do
  		echo Exporting table $TABLE
  		psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM $TABLE where (organisation_id = $1 or organisation_id = 1)) TO STDOUT;" openchs
  done
