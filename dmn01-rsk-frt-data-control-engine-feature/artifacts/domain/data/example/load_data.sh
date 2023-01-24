#!/bin/bash

echo "PROJECT_ID = ${PROJECT_ID}"
echo "DATASET = ${DCE_DATASET}"
echo "BUCKET = ${BUCKET}"
echo "WORKSPACE = ${WORKSPACE}"

echo "Upload files into cloud storage for control FIN_GLO_001"
gsutil -m cp -r ${WORKSPACE}/artifacts/domain/data/example/FIN_GLO_001_ACBS_BALANCES.csv gs://$BUCKET
gsutil -m cp -r ${WORKSPACE}/artifacts/domain/data/example/FIN_GLO_001_GL_BALANCES.csv gs://$BUCKET

echo "Upload files into cloud storage for control FIN_EOD_001"
gsutil -m cp -r ${WORKSPACE}/artifacts/domain/data/example/FIN_EOD_001_ACBS_FINANCE_GCP_TOTALS.csv gs://$BUCKET
gsutil -m cp -r ${WORKSPACE}/artifacts/domain/data/example/FIN_EOD_001_BROWNFIELD_ACBS_CONTROL_FILE.csv gs://$BUCKET

echo "BQ command to create table and load data from files for control FIN_GLO_001"
bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $DATASET.${glo_001_bq_table} 2> /dev/null || true
bq --project_id=$PROJECT_ID --location=europe-west2 load --source_format=CSV --autodetect $DATASET.${glo_001_bq_table} gs://$BUCKET/FIN_GLO_001_ACBS_BALANCES.csv
bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $DATASET.${glo_001_acbs_table} 2> /dev/null || true
bq --project_id=$PROJECT_ID --location=europe-west2 load --source_format=CSV --autodetect $DATASET.${glo_001_acbs_table} gs://$BUCKET/FIN_GLO_001_GL_BALANCES.csv

echo "BQ command to create table and load data from files for FIN_EOD_001"
bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $DATASET.${eod_001_acbs_table} 2> /dev/null || true
bq --project_id=$PROJECT_ID --location=europe-west2 load --source_format=CSV --autodetect $DATASET.${eod_001_acbs_table} gs://$BUCKET/FIN_EOD_001_ACBS_FINANCE_GCP_TOTALS.csv
bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $DATASET.${eod_001_bq_table} 2> /dev/null || true
bq --project_id=$PROJECT_ID --location=europe-west2 load --source_format=CSV --autodetect $DATASET.${eod_001_bq_table} gs://$BUCKET/FIN_EOD_001_BROWNFIELD_ACBS_CONTROL_FILE.csv

echo "Update table/view labels"
bq update \
    --set_label cmdb_appid:al15407 \
    --set_label component:data-control-engine \
    --set_label owner:sbs-dmg \
    --set_label troux_id:sbs-dmg \
    --set_label cost_centre:c-pr0101-s1-91 \
    --set_label dataclassification:confidential \
    $DATASET.${glo_001_acbs_table}

bq update \
    --set_label cmdb_appid:al15407 \
    --set_label component:data-control-engine \
    --set_label owner:sbs-dmg \
    --set_label troux_id:sbs-dmg \
    --set_label cost_centre:c-pr0101-s1-91 \
    --set_label dataclassification:confidential \
    $DATASET.${glo_001_bq_table}

bq update \
    --set_label cmdb_appid:al15407 \
    --set_label component:data-control-engine \
    --set_label owner:sbs-dmg \
    --set_label troux_id:sbs-dmg \
    --set_label cost_centre:c-pr0101-s1-91 \
    --set_label dataclassification:confidential \
    $DATASET.${eod_001_acbs_table}

bq update \
    --set_label cmdb_appid:al15407 \
    --set_label component:data-control-engine \
    --set_label owner:sbs-dmg \
    --set_label troux_id:sbs-dmg \
    --set_label cost_centre:c-pr0101-s1-91 \
    --set_label dataclassification:confidential \
    $DATASET.${eod_001_bq_table}

echo "Done"
