#!/bin/bash

export DBT_PROFILE_DIR=~/.dbt
export DBT_PROJECT_DIR=$(pwd)

echo "Starting dbt job run at $(date)"

python scripts/run_dbt.py --project-dir $DBT_PROJECT_DIR seed
if [ $? -ne 0 ]; then
    echo "Error: dbt seed"
    exit 1
fi

python scripts/run_dbt.py --project-dir $DBT_PROJECT_DIR run
if [ $? -ne 0 ]; then
    echo "Error: dbt run"
    exit 1
fi

python scripts/run_dbt.py --project-dir $DBT_PROJECT_DIR test
if [ $? -ne 0 ]; then
    echo "Error: dbt test "
    exit 1
fi

echo "dbt job completed successfully at $(date)"