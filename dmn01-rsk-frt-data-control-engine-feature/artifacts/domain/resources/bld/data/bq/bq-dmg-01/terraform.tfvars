################################################################################
# ****** Below values are for reference only. Actual values may differ. ****** #
################################################################################
#

## project_id = The ID of the project where this big query dataset will be created
## dataset_id = A unique ID for this dataset, without the project name. e.g. gke_logs_dataset
## location = (Optional) The geographic location where the dataset should reside, default = europe-west2
## default_table_expiration_ms = (Optional) The default lifetime of all tables in the dataset, in milliseconds. The minimum value is 3600000 milliseconds (one hour), default = null
## default_partition_expiration_ms = (Optional) The default lifetime of all partitions in the dataset, in milliseconds. The minimum value is 3600000 milliseconds (one hour), default = null
## friendly_name = (Optional) A descriptive name for the dataset following ep_[a-z]{3}_(ide|bld|int|pre|prd|tst)_[a-z]{3}_[a-z0-9]{2,3}_[a-z0-9-]{0,30}, default = null
## description = (Optional) A user-friendly description of the dataset, default     = null
## delete_contents_on_destroy = (Optional) If set to true, delete all the tables in the dataset when destroying the resource; otherwise, destroying the resource will fail if tables are present, default = true
## labels = The labels associated with this dataset.
## env_labels = (Optional) Map of key/value pairs that will be associated with EACH topic provided in topic_names, default = null
## audit_labels = Map of key/value pairs that will be associated with EACH topic provided in topic_names, default = null
## dataset_access = Access rules applied to all datasets in sink if no specific ones are defined.
## default_encryption_configuration = ( Optional ) The default encryption key for all tables in the dataset. Once this property is set, all newly-created partitioned tables in the dataset will have encryption key set to this value, unless table creation request (or query) overrides the key. Structure is documented below.
##                                    key_name - (Required) the key to use to encrypt/decrypt secrets. This variable is required only if the data classification is confidential.
project_id    = "demo-dce-bld-01-c123"
dataset_id    = "demo_dce_test"
location      = "europe-west2"
friendly_name = "data-control-engine"

labels = {
  "cmdb_appid"         = "al15407"
  "component"          = "data-control-engine"
  "owner"              = "demo-dce"
  "troux_id"           = "demo-dce"
  "cost_centre"        = "c-pr0101-s1-91"
  "dataclassification" = "confidential"
}
access_config = {

  # Write access to DCE Service Account
  md_writer_access = {
    role          = ["roles/bigquery.dataEditor", "roles/bigquery.user"]
    user_by_email = "svc-demo-data-control-engine@demo-dce-bld-01-c123.iam.gserviceaccount.com"
  },
  # Write access to View Creating Service Account
  view_creator_writer_access = {
    role          = ["roles/bigquery.dataEditor", "roles/bigquery.user"]
    user_by_email = "svc-demo-dce-template-views@demo-dce-bld-01-c123.iam.gserviceaccount.com"
  },

}
schema_dir = "."

kms_key_ring   = "krs-kms-demo-euwe2-bqd"
kms_location   = "europe-west2"
kms_project_id = "demo-kms-bld-01-f123"
kms_crypto_key = "keyhsm-kms-demo-euwe2-bqd"

tables = {
  "dq_outputs" = {
    kms_crypto_key = "keyhsm-kms-sbs-euwe2-bqt"
    kms_project_id = "sbs-kms-bld-01-f72f",
    kms_location   = "europe-west2",
    kms_key_ring   = "krs-kms-sbs-euwe2-bqt"
  }
}

views = []
