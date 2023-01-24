#!/usr/bin/env bash

start=`date +%s`

echo "Starting load-rules run"

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


echo "********************Running gsutils cp to from ${HOME_DIR}/rules/* to bucket gs://${BUCKET_NAME}********************"

gsutil -m cp -r ${HOME_DIR}/rules/* gs://${BUCKET_NAME}

end=`date +%s`
runtime=$((end-start))
echo "********************Execution completed for $PROJECT_ID project and took $runtime second.********************"