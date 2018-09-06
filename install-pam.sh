#!/bin/bash

# set configuration variables
export PROC_SERVER_PASSWORD=pspass
export BUS_CENTRAL_PASSWORD=bcpass
export KIE_ADMIN_USER=admin
export KIE_ADMIN_PWD=admin
export PROJ_NAME=rhpamauthenv
export OC_PAM_TEMPLATES_DIR=rhpam-7.0.2-openshift-templates


# login admin to setup imagestreams in openshift project
oc login --username=admin --password=admin --insecure-skip-tls-verify=true

# install PAM image streams
oc project openshift
oc create -f rhpam-7.0.2-openshift-templates/rhpam70-image-streams.yaml

# login as developer to setup pam
oc login --username=developer  --password=developer --insecure-skip-tls-verify=true

# creae the pam project within openshift
oc new-project $PROJ_NAME

# create process server cert
mkdir -p certs/procserver
cd certs/procserver
rm keystore.jks
keytool -genkeypair -alias jboss -keyalg RSA -keystore keystore.jks -storepass $PROC_SERVER_PASSWORD -keypass $PROC_SERVER_PASSWORD\
	--dname "CN=jsmith,OU=Engineering,O=mycompany.com,L=Raleigh,S=NC,C=US"

oc delete secret kieserver-app-secret
oc create secret generic kieserver-app-secret --from-file=keystore.jks
cd ../..

# create business central certs
mkdir -p certs/buscentral
cd certs/buscentral
rm keystore.jks
keytool -genkeypair -alias jboss -keyalg RSA -keystore keystore.jks -storepass $BUS_CENTRAL_PASSWORD -keypass $BUS_CENTRAL_PASSWORD\
	--dname "CN=jsmith,OU=Engineering,O=mycompany.com,L=Raleigh,S=NC,C=US"

oc delete secret businesscentral-app-secret
oc create secret generic businesscentral-app-secret --from-file=keystore.jks
cd ../..

# create the app
oc new-app -f $OC_PAM_TEMPLATES_DIR/templates/rhpam70-authoring.yaml \
   -p KIE_ADMIN_USER=$KIE_ADMIN_USER \
   -p KIE_ADMIN_PWD=$KIE_ADMIN_PWD \
   -p BUSINESS_CENTRAL_HTTPS_SECRET=businesscentral-app-secret \
   -p KIE_SERVER_HTTPS_SECRET=kieserver-app-secret \
   -p APPLICATION_NAME=$PROJ_NAME \
   -p BUSINESS_CENTRAL_HTTPS_NAME=jboss \
   -p KIE_SERVER_HTTPS_NAME=jboss \
   -p BUSINESS_CENTRAL_HTTPS_PASSWORD=$BUS_CENTRAL_PASSWORD \
   -p KIE_SERVER_HTTPS_PASSWORD=$PROC_SERVER_PASSWORD 
