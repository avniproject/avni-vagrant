for TABLE in $(cat ./database/non-tx-tables-with-org-id.txt)
	do
  		echo Exporting table $TABLE
  		psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM $TABLE where (organisation_id in ($1, 1)) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY $TABLE FROM STDIN;" openchs
  done

psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM account) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY account FROM STDIN;" openchs
psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM account_admin) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY account_admin FROM STDIN;" openchs
psql -h localhost -p 2203 -U openchs -c "COPY (SELECT catchment_address_mapping.* FROM catchment_address_mapping join catchment c on catchment_address_mapping.catchment_id = c.id where c.organisation_id = $1) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY catchment_address_mapping FROM STDIN;" openchs
psql -h localhost -p 2203 -U openchs -c "COPY (SELECT decision_concept.* FROM decision_concept join concept c on decision_concept.concept_id = c.id where c.organisation_id in ($1, 1))) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY decision_concept FROM STDIN;" openchs
#psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM audit) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY audit FROM STDIN;" openchs

for TABLE in flyway_schema_history organisation organisation_group privilege approval_status
  do
    psql -h localhost -p 2203 -U openchs -c "COPY (SELECT * FROM $TABLE) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY $TABLE FROM STDIN;" openchs
  done
