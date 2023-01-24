################################################################################
# ****** Below values are for reference only. Actual values may differ. ****** #
################################################################################
#
## Manage IAM permissions for service accounts and groups
#
## project_id : Service project id for IAM needs to be changed
## project_permissions : Service account for project which needs to be created 
##                       and mapped against the roles
## project_iam_conditions : IAM Conditions for roles gratted to a speficic service account
## group_project_permissions : Provided, group names should be valid and availble in gsuite domain.
##                             Assign the roles to group. In example "gg_mgmt-cmp-tst_devops_o" 
##                             which is an existing group
## remote_project_permissions : Remote service account should be already created,
##                              as only roles can be applied
## remote_project_project_iam_conditions : IAM Conditions for roles gratted to a remote project speficic service account
## org_domain : Org domain name with which group is existing
## workload_identity:  is the recommended way to access Google Cloud services from within GKE.
## workload_identity_na : Non autoritative work load identity mapping, specific usecase for multitenancy cluster
project_id = "demo-dce-bld-01-c123"
project_permissions = {
  # project permission goes here
  "svc-demo-data-control-engine" = ["roles/iam.workloadIdentityUser"]
  "svc-demo-dce-template-views"  = ["roles/iam.workloadIdentityUser"]
  "svc-demo-dce-template-rules"  = ["roles/iam.workloadIdentityUser"]
}
project_iam_conditions = {

}
group_project_permissions = {

}
remote_project_permissions = {

}
org_domain = "e.lloydsbanking.com"
workload_identity = {
  "svc-demo-data-control-engine" = {
    "namespaces"    = ["ns-kcl-demo-data-control-engine"]
    "kubernetes_sa" = "sa-demo-data-control-engine"
  },
  "svc-demo-dce-template-views" = {
    "namespaces"    = ["ns-kcl-sbs-dmg-data-control-engine"]
    "kubernetes_sa" = "sa-demo-dce-template-views"
  },
  "svc-demo-dce-template-rules" = {
    "namespaces"    = ["ns-kcl-sbs-dmg-data-control-engine"]
    "kubernetes_sa" = "sa-demo-dce-template-rules"
  }
}
workload_identity_na = {

}
serviceaccount_user = {

}
