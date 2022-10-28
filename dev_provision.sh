#!/bin/bash

#source scripts/.env

# Default option is to refresh DB with the starter db.
REFRESH_DB="starter_db"
VERBOSE=1
# https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options
# https://stackoverflow.com/a/7680682
optspec=":qh-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                refresh-db)
                    val="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                    ;;
                refresh-db=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%="$val"}
                    echo "Parsing option: '--${opt}', value: '${val}'" >&2
                    if [[ $val == "skip" ]]; then
                      echo "Skipping DB refresh"
                      REFRESH_DB="skip"
                    elif [[ $val == "qa" ]]; then
                      echo "Refresh DB with QA database"
                      REFRESH_DB="qa"
                    fi
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h)
            echo "usage: $0 [--refresh-db[=]qa|skip]" >&2
            exit 2
            ;;
        q)
            VERBOSE=0
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done

# Check OS and file permissions.
OS="windows"

case "$(uname -s)" in

   Darwin)
     OS='mac'
     ;;

   Linux)
     OS='linux'
     ;;

   *)
     uname -s
     ;;
esac

# if [[ $OS = "linux" ]] ; then
#   echo "Fixing folder ownership."
#   sudo chown www-data ./drupal-project/web/sites/default/files -R
# fi

# echo "Preparing private file folder."
# mkdir -p ./env/private-files
# chmod -R 777 ./env/private-files > /dev/null 2>&1

echo "Restarting Docker."
if [[ $VERBOSE == 1 ]]; then
  docker-compose stop
  docker-compose up -d
  docker container ls
else
  docker-compose stop > /dev/null 2>&1
  docker-compose up -d > /dev/null 2>&1
fi

echo "Installing Matomo using composer."
  docker-compose exec "${SERVICE}" bash -c "cd /var/www/; composer install"

# echo "Configuring phpcs."
# PHPCS is now in composer.json > post install.

# echo "Enabling pre-commit and pre-push hooks."
# rm -f .git/hooks/pre-commit
# ln -s ../../scripts/pre-commit .git/hooks/pre-commit
# rm -f .git/hooks/pre-push
# ln -s ../../scripts/pre-push .git/hooks/pre-push

# if [[ $REFRESH_DB == "starter_db" ]]; then
#   # Import DB from starter DB.
#   echo "Importing starter DB."
#   ./docker_sync_db_from_starter_db.sh

#   # If we already destroyed the whole DB, there's no harm in importing config.
#   docker-compose exec "${SERVICE}"  bash -c "cd /var/www/web/; drush -y deploy"

# #elif [[ $REFRESH_DB == "skip" ]]; then
# else
#   # If didn't destory the DB, just clear code cache.
#   echo "Clearing cache and running deploy hooks."
#   docker-compose exec "${SERVICE}"  bash -c "cd /var/www/web/; drush updb -y; drush cr; drush -y deploy:hook"
# fi


