#!/usr/bin/env bash

heroku_staging_name=$1
heroku_prod_name=$2

function print_usage {
  echo "Usage:  $0 <heroku-staging-name> <heroku-prod-name>"
  echo
  echo "Heroku pipelines currently does not compare config vars and publishes the exact slug"
  echo "during promotion. This can crash the app if critical config vars are not added to prod."
  echo "$0 is for comparing staging and prod config vars before a deploy to avoid this issue."
  echo
  echo "Example:"
  echo "  $0 some-staging-app some-prod-app"
  echo "=> Staging config vars match prod"
}

if [ -z $heroku_staging_name ] ; then
  echo
  echo -e "\033[31m Heroku staging app name must be provided! \033[0m"
  echo

  print_usage
  exit 1
fi

if [ -z $heroku_prod_name ] ; then
  echo
  echo -e "\033[31m Heroku production app name must be provided! \033[0m"
  echo
  print_usage
  exit 2
fi

STAGING_KEYS=`heroku config -s --app $heroku_staging_name | ag -o '[A-Z].*(?==)'`
PROD_KEYS=`heroku config -s --app $heroku_prod_name | ag -o '[A-Z].*(?==)'`

# Replace these arrays with whichever keys are fine to keep for staging or prod
staging_specific_keys=("EMAIL_RECIPIENTS" "KEY1" "KEY2")
prod_specific_keys=("BUGSNAG_API_KEY" "HEROKU_POSTGRESQL_JADE_URL" "INTERCOM_APP_ID" "INTERCOM_SECRET_KEY")

filtered_staging_string='echo "$STAGING_KEYS" '
for i in "${staging_specific_keys[@]}"
do
  filtered_staging_string+=" | sed /$i/d"
done

filtered_prod_string='echo "$PROD_KEYS" '
for i in "${prod_specific_keys[@]}"
do
  filtered_prod_string+=" | sed /$i/d"
done

FILTERED_STAGING=`eval "$filtered_staging_string"`
FILTERED_PROD=`eval "$filtered_prod_string"`

KEY_DIFF=`diff <(echo "$FILTERED_STAGING") <(echo "$FILTERED_PROD")`

# Check if config vars match
if [ -z "$KEY_DIFF" ]
then
  echo
  echo -e "\033[32m Staging config vars match prod \033[0m"
  echo
  exit 0
else
  echo -e "\033[31m Staging DOES NOT match prod \033[0m"
  echo
  echo "Differences:"
  echo $KEY_DIFF
  exit 3
fi
