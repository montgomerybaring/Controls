#!/bin/bash

echo "PROJECT_ID = ${PROJECT_ID}"
echo "ACBS_SOURCE_DATASET = ${ACBS_SRC_DATASET}"
echo "DCE_DATASET = ${DCE_DATASET}"

echo "**BQ delete existing difference views**"
bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $PROJECT_ID:$DCE_DATASET.$eod_001_diff_view 2> /dev/null || true
bq rm --project_id=$PROJECT_ID --location=europe-west2 -f -t $PROJECT_ID:$DCE_DATASET.$glo_001_diff_view 2> /dev/null || true
echo "Difference-views deleted"

echo "**BQ create view for difference for FIN_EOD_001**"
bq mk \
--nouse_legacy_sql \
--project_id=$PROJECT_ID \
--view "SELECT
    IFNULL(dce_bq.CLMS_LOAN_CCY, brownfield_data.CLMS_LOAN_CCY) as CLMS_LOAN_CCY,
    IFNULL(dce_bq.CLMS_CMR_PRINCIPAL,0) as ACBS_GCP_TOTALS,
    IFNULL(brownfield_data.CLMS_CMR_PRINCIPAL,0) as ACBS_FILE_TOTALS,
    IFNULL(brownfield_data.FILE_DATE,dce_bq.FILE_DATE) as DATE,
    CAST(IFNULL(dce_bq.FILE_DATE, brownfield_data.FILE_DATE) as TIMESTAMP) as UPDATED_AT,
    ROUND(ABS(IFNULL(dce_bq.CLMS_CMR_PRINCIPAL,0) - IFNULL(brownfield_data.CLMS_CMR_PRINCIPAL,0)),2) as DIFF
FROM ${ACBS_SRC_DATASET}.${eod_001_bq_table} dce_bq
FULL OUTER JOIN ${ACBS_SRC_DATASET}.${eod_001_acbs_table} brownfield_data
  ON dce_bq.CLMS_LOAN_CCY = brownfield_data.CLMS_LOAN_CCY
  and dce_bq.FILE_DATE = brownfield_data.FILE_DATE
  where brownfield_data.FILE_DATE in (select max(dce_bq.FILE_DATE) from ${ACBS_SRC_DATASET}.${eod_001_bq_table} dce_bq)
ORDER BY CLMS_LOAN_CCY " \
--location=europe-west2 \
${DCE_DATASET}.${eod_001_diff_view}

bq show --project_id=$PROJECT_ID \
--schema --format=prettyjson $DCE_DATASET.$eod_001_diff_view

echo "**BQ create view for difference for FIN_GLO_001**"
bq mk \
--nouse_legacy_sql \
--project_id=$PROJECT_ID \
--view "SELECT
    IFNULL(brownfield_data.FILE_NAME, dce_bq.FILE_NAME) as FILE_NAME,
    IFNULL(brownfield_data.CO, CASE
      WHEN dce_bq.CLMS_PORT_ID = 'I*+Z*+C*' THEN 4655
  	  WHEN dce_bq.CLMS_PORT_ID = 'L*' THEN 433
  	  WHEN dce_bq.CLMS_PORT_ID = 'B*' THEN 4439
    END) as PORT_ID,
    IFNULL(brownfield_data.BU, dce_bq.CLMS_PROF_CENTRE) as PROF_CENTRE,
    IFNULL(brownfield_data.CCY, dce_bq.CLMS_LOAN_CCY) as CCY,
    IFNULL(brownfield_data.BALANCE, 0) as GL_BALANCE,
    IFNULL(dce_bq.SUMIFS, 0) as ACBS_BALANCE,
    IFNULL(dce_bq.FILE_DATE, brownfield_data.FILE_DATE) as FILE_DATE,
    CAST(IFNULL(dce_bq.FILE_DATE, brownfield_data.FILE_DATE) as TIMESTAMP) as UPDATED_AT,
	ROUND(ABS(IFNULL(brownfield_data.BALANCE,0) - IFNULL(dce_bq.SUMIFS,0)),2) as DIFF
FROM ${ACBS_SRC_DATASET}.${glo_001_acbs_table} brownfield_data
FULL OUTER JOIN ${ACBS_SRC_DATASET}.${glo_001_bq_table} dce_bq
	ON brownfield_data.BU = dce_bq.CLMS_PROF_CENTRE AND brownfield_data.CCY = dce_bq.CLMS_LOAN_CCY
	AND brownfield_data.CO = CASE
	       WHEN dce_bq.CLMS_PORT_ID = 'I*+Z*+C*' THEN 4655
	       WHEN dce_bq.CLMS_PORT_ID = 'L*' THEN 433
	       WHEN dce_bq.CLMS_PORT_ID = 'B*' THEN 4439
       END
    AND brownfield_data.FILE_DATE = dce_bq.FILE_DATE
    where brownfield_data.FILE_DATE in (select max(dce_bq.FILE_DATE) from ${ACBS_SRC_DATASET}.${glo_001_bq_table} dce_bq)
ORDER BY brownfield_data.CCY" \
--location=europe-west2 \
${DCE_DATASET}.${glo_001_diff_view}

echo "Update table/view labels"
bq update \
    --set_label cmdb_appid:al15407 \
    --set_label component:data-control-engine \
    --set_label owner:sbs-dmg \
    --set_label troux_id:sbs-dmg \
    --set_label cost_centre:c-pr0101-s1-91 \
    --set_label dataclassification:confidential \
    ${DCE_DATASET}.${eod_001_diff_view}

bq update \
    --set_label cmdb_appid:al15407 \
    --set_label component:data-control-engine \
    --set_label owner:sbs-dmg \
    --set_label troux_id:sbs-dmg \
    --set_label cost_centre:c-pr0101-s1-91 \
    --set_label dataclassification:confidential \
    ${DCE_DATASET}.${glo_001_diff_view}

bq show --project_id=$PROJECT_ID \
--schema --format=prettyjson $DCE_DATASET.$glo_001_diff_view
