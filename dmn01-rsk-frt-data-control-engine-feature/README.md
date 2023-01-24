# sbs-dmg-dce-domain-template

This is a template repository that can be cloned by a domain that is installing Data-Management's Data-Control-Engine within their own project.

------------------------------------------------

## DCE Applications

This repo contains 4 deployable applications:
- dce-template-engine - The engine application itself, consuming Controls, executing them and publishing outcome messages.
- dce-template-rules - A utility to allow domains to load the YAML file control definitions into a Cloud Storage Bucket.
- dce-template-views - An optional utility, allowing the creation of views within a domains BigQuery dataset
- dce-template-data - **NOT TO BE USED BY DOMAINS.** Used only by DCE team for testing purposes.

## Configuration

Infomation on how to deploy and configure the engine / utilities can be found **[here.](https://confluence.devops.lloydsbanking.com.mcas.ms/display/EDSDP/New+Runbook%3A+DCE+Installation+in+BLD)**


## Running the DCE locally

The DCE can be run locally from the repo containing the DCE source code, found **[here.](https://github.com/lbg-gcp-foundation/sbs-dmg-data-control-engine)**

A guide on running the engine can be found in the README.md file there.


## Running Jenkins Pipelines

Jenkins pipelines have the following options:

 - *Environment* (dropdown list): Can be used to select a series of environment variables used in the Jenkins deployment. 
 These variables can be found in `piplines/conf/jenkinsconfig.yaml`.
 - *Pipeline* (dropdown list): Choose which application is being built / deployed.
 - *ImageTag* (free-text): Specify a specific tag to be released.
 - *ClearDCEOutput* (tickbox): This will clear the output logs of your engine, efectivly wiping its 'memory', 
 allowing it to run on data which it has run on in the past.
 - *BuildImage* (tickbox): Builds a docker image, tags it, and saves that to GCR.
 - *DeployChart* (tickbox): Deploys the helm chart for the selected pipeline onto a Kubernetes cluster. 
 Cluster info defined within `piplines/conf/jenkinsconfig.yaml`. Does **not** need to be a built image in order to deploy the chart to BLD.
 - *ReleaseImage* (tickbox): Creates a 'release' of the pipeline in GitHub, and saves the image in Nexus. Requires the git commit prefix of 'release' or 'generic'.


## Check deployment of pods on Kubernetes BLD

The list of commands which help read information from GCP
```
# Get BLD credentials to connect with BLD kubernetes
gcloud container clusters get-credentials sbs-dmg-bld-01-kcl-01-euwe2 --region europe-west2

# Get a list of DCE images in CTL
gcloud container images list-tags eu.gcr.io/sbs-ctl-bld-01-54a6/dmg/sbs-dmg-data-control-engine

# Get list of cronjobs
kubectl get cronjobs --all-namespaces

# Get list of jobs
kubectl get jobs --all-namespaces

# Get list of pods for DCE
kubectl get pods -n ns-kcl-sbs-dmg-data-control-engine

# Read logs from completed pods for DCE
kubectl logs dce-template-engine-27548040-l9thb -n ns-kcl-sbs-dmg-data-control-engine
```
