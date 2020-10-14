#!/bin/bash

ORGID=$(aws organizations describe-organization --query 'Organization.Id' --output text)
ORGROOTID=$(aws organizations list-roots --query 'Roots[].Id' --output text)
LEVEL1OU=$(aws organizations list-organizational-units-for-parent --parent-id $ORGROOTID --query 'OrganizationalUnits[*].Id' --output text) #--output text)

echo "##### OU is: Root #####"
aws organizations list-organizational-units-for-parent \
  --parent-id $ORGROOTID \
  --query 'OrganizationalUnits[*].{Name:Name,Id:Id}' \
  --output table

for ou in $LEVEL1OU;
    do 
      echo "##### OU is: $(aws organizations describe-organizational-unit --organizational-unit-id $ou --query 'OrganizationalUnit.Name' --output text ) #####"
        aws organizations list-organizational-units-for-parent \
        --parent-id $ou \
        --query 'OrganizationalUnits[*].{Name:Name,Id:Id}' \
        --output table
    done

exit