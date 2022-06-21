#individual audit individual_relationship  individual_relationship_type  program_encounter  program_enrolment  encounter  checklist_detail  checklist_item_detail

Tables="audit individual program_enrolment"

for Table in $Tables
	do
  		echo "Export/Importing table $Table for $1"
  		psql -h localhost -p 2203 -U $1 -c "COPY (SELECT * FROM $Table) TO STDOUT;" openchs | psql -h localhost -U openchs -c "COPY $Table FROM STDIN;" openchs
  		psql -h localhost -p 2203 -U $1 -c "SELECT setval('$Table_id_seq', COALESCE((SELECT MAX(id)+1 FROM $Table), 1), false);" openchs
  done
