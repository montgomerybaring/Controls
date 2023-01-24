#!/bin/bash

PROJECT_ID="${PROJECT_ID:=sbs-dmg-ide-04-fb79}"
echo "PROJECT_ID = ${PROJECT_ID}"
DATASET="${DATASET:=seweryn_acbs_test}"
echo "DATASET = ${DATASET}"
BUCKET="${BUCKET:=seweryn_acbs_test}"
echo "BUCKET = ${BUCKET}"

echo "Clear existing resources"
bq rm -r -f --project_id=$PROJECT_ID -d $DATASET
gsutil rm -r -f gs://$BUCKET 2> /dev/null || true

echo "Create bucket"
gsutil mb -p $PROJECT_ID -l europe-west2 -b on gs://$BUCKET

echo "BQ create dataset for ACBS test"
bq mk --project_id=$PROJECT_ID --location=europe-west2 $DATASET
