################################################################################
# ****** Below values are for reference only. Actual values may differ. ****** #
################################################################################
#
## random_suffix : random string used for resource suffix
## project_id: Service project id where storage bucket needs to be created
## region : Available region. Currently "europe-west2" is only supported
## labels: Labels to be attached to the buckets.
## bucket_name : Storage bucket name. after bucket creation, random_suffix will be appended with name
## storage_class: available storage class is regional
## troux_id : Troux id of project
## cost_centre : Cost center for project
## owner : Owner of the resource
## environment : Use environment identifier. Availble options are [ bld | int | tst | pre | prd ]
## versioning : bucket versioning value [true | false], true allows the data to be restored.
## dataclassification : storage data classification, available options ["public", "limited", "highly-confidential", "confidential"]
## kms_project_id : KMS project id where hsm key resids for bucket encryption
## kms_key_ring : KMS Key ring for customer managed kms keys to be stored in
## kms_crypto_key : KMS crypto key ring in the kms key ring supplied
## bucket_policy_only : Enables Bucket Policy Only access to a bucket - https://cloud.google.com/storage/docs/uniform-bucket-level-access
## lifecycle_rules : (Optional) The bucket's Lifecycle Rules configuration. Multiple blocks of this type are permitted - https://cloud.google.com/storage/docs/lifecycle#configuration
##                  Default value is an empty list
## iam_binding : Authoritative for a given role. https://www.terraform.io/docs/providers/google/r/storage_bucket_iam.html#google_storage_bucket_iam_binding"
##               Please note that any of the IAM permission needs to be approved by security team
random_suffix = false
project_id    = "demo-dce-bld-01-c123"
region        = "europe-west2"
bucket_name        = "demo_acbs_bucket_test"
storage_class      = "regional"
troux_id           = "demo-dce"
cost_centre        = "c-pr0101-s1-91"
owner              = "dmg"
environment        = "bld"
versioning         = true
dataclassification = "confidential"

labels = {
  cmdb_appid         = "al15407"
}

iam_binding = {
  "roles/storage.admin" = [
    "serviceAccount:svc-demo-data-control-engine@demo-dce-bld-01-c123.iam.gserviceaccount.com"
  ]
  "roles/storage.objectAdmin" = [
    "serviceAccount:svc-demo-data-control-engine@demo-dce-bld-01-c123.iam.gserviceaccount.com",
    "serviceAccount:svc-demo-dce-template-rules@demo-dce-bld-01-c123.iam.gserviceaccount.com"
  ]
}


kms_project_id = "demo-kms-bld-01-f123"
kms_key_ring   = "krs-kms-demo-euwe2-stb"
kms_crypto_key = "keyhsm-kms-demo-euwe2-stb"
