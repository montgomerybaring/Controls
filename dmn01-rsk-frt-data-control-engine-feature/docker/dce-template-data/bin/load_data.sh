#!/usr/bin/env bash

start=`date +%s`

echo "Starting load-data run"

#getting job id for running job.
authorizedAccounts=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
#check if active accounts found.
echo $authorizedAccounts

if [ -z $authorizedAccounts ]; then
  echo "Account Not Authorized to Run..."
    # exit 1
else
  echo "Account Authorized to Run..."
fi


echo "**************** Running gcloud config list ******************"  
gcloud config list --verbosity debug


echo "******************** Running gsutils cp to from ${HOME_DIR}/data/*.csv to bucket gs://${BUCKET_NAME}/data/ ********************"

gsutil -m cp -r ${HOME_DIR}/data/*.csv gs://${BUCKET_NAME}/data/

echo "******************** Loading data into BQ dataset ${DATASET} ********************"
for filename in ${HOME_DIR}/data/*.csv; do
    # Find split filename
    IFS='/'
    read -a strarr1 <<< "$filename"
    element_count=$((${#strarr1[*]} - 1))
    file_split1=${strarr1[$element_count]}
    IFS='.'
    read -a strarr2 <<< "$file_split1"
    file_split_name=${strarr2[0]}
    echo "File is called ${file_split_name}"

    # Clear existing data from table
    bq query --nouse_legacy_sql "DELETE FROM ${DATASET}.${file_split_name} WHERE True"
    # Load table with data in loaded CSV
    bq load \
    --project_id=$PROJECT_ID \
    --location=europe-west2 \
    --skip_leading_rows=1 \
    --source_format=CSV \
    $DATASET.$file_split_name gs://$BUCKET_NAME/data/$file_split_name.csv

done

end=`date +%s`
runtime=$((end-start))
echo "Execution completed for $PROJECT_ID project and took $runtime second."
