#individual audit individual_relationship  individual_relationship_type  program_encounter  program_enrolment  encounter  checklist_detail  checklist_item_detail

Tables="audit individual program_enrolment"

for Table in $Tables
	do
  		echo Export/Importing table $Table
  		psql -h localhost -p 2203 -U $1 -c "COPY (SELECT * FROM $Table) TO STDOUT;" openchs | psql -h localhost -U $Table -c "COPY $Table FROM STDIN;" openchs
  done
