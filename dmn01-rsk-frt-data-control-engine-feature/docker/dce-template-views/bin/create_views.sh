#!/usr/bin/env bash

start=`date +%s`

echo "**************** Starting load-rules run ****************"


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



IFS=','
read -a lable_split <<< "$VIEW_LABELS"
echo "View lables are as follows:"
lable_command=()
for ele in ${lable_split[@]}; do
    echo $ele
    lable_command+=(--set_label "$ele")
done



echo "Loading data into BQ dataset ${DATASET}"

for filename in ${HOME_DIR}/views/*.sql; do
    echo "******* Processing file $filename *******"

    # Find split filename
    IFS='/'
    read -a strarr1 <<< "$filename"
    element_count=$((${#strarr1[*]} - 1))
    file_split1=${strarr1[$element_count]}
    IFS='.'
    read -a strarr2 <<< "$file_split1"
    view_name=${strarr2[0]}
    echo "File is called ${view_name}"

    echo "******* Removing $view_name if in existence *******"
    bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $DATASET.$view_name 2> /dev/null || true
    
    # Reading file, and interprating variables
    view_sql_unparsed=$(cat /home/appuser/views/${view_name}.sql)
    echo "echo \"" > temp.out
    echo "$view_sql_unparsed" >> temp.out
    echo "\"" >> temp.out
    view_sql=$(source temp.out)

    echo "******* Creating $view_name as the following: *******"
    echo $view_sql
    bq mk \
    --nouse_legacy_sql \
    --project_id=$PROJECT_ID \
    --location=europe-west2 \
    --view="${view_sql}" \
    $DATASET.$view_name

    if [ ${#lable_split[@]} -gt 0 ]; then
        echo "Updaing the view $view_name with the following lables:"
        echo "${lable_command[@]}"
        bq update ${lable_command[@]} $DATASET.$view_name
    fi

done

end=`date +%s`
runtime=$((end-start))
echo "Execution completed for $PROJECT_ID project and took $runtime second."