#!/bin/bash

source install-pam.properties

# login admin to setup imagestreams in openshift project
oc login --username=admin --password=admin --insecure-skip-tls-verify=true

# install PAM image streams
oc project openshift
oc create -f ${OC_PAM_TEMPLATES_DIR}/${OC_PAM_IMAGE_STREAMS}

# login as developer to setup pam
oc login --username=developer  --password=developer --insecure-skip-tls-verify=true

# creae the pam project within openshift
oc new-project ${PROJECT_NAME}

# create process server cert
mkdir -p certs/procserver
cd certs/procserver
rm keystore.jks
keytool -genkeypair -alias jboss -keyalg RSA -keystore keystore.jks -storepass ${PROC_SERVER_PASSWORD} -keypass ${PROC_SERVER_PASSWORD} \
	--dname "CN=jsmith,OU=Engineering,O=mycompany.com,L=Raleigh,S=NC,C=US"

oc delete secret kieserver-app-secret
oc create secret generic kieserver-app-secret --from-file=keystore.jks
cd ../..

# create business central certs
mkdir -p certs/buscentral
cd certs/buscentral
rm keystore.jks
keytool -genkeypair -alias jboss -keyalg RSA -keystore keystore.jks -storepass ${BUS_CENTRAL_PASSWORD} -keypass ${BUS_CENTRAL_PASSWORD} \
	--dname "CN=jsmith,OU=Engineering,O=mycompany.com,L=Raleigh,S=NC,C=US"

oc delete secret businesscentral-app-secret
oc create secret generic businesscentral-app-secret --from-file=keystore.jks
cd ../..

# create the app
oc new-app -f ${OC_PAM_TEMPLATES_DIR}/${OC_PAM_APP_TEMPLATE} \
   -p KIE_ADMIN_USER=${KIE_ADMIN_USER} \
   -p KIE_ADMIN_PWD=${KIE_ADMIN_PWD} \
   -p BUSINESS_CENTRAL_HTTPS_SECRET=businesscentral-app-secret \
   -p KIE_SERVER_HTTPS_SECRET=kieserver-app-secret \
   -p APPLICATION_NAME=${APPLICATION_NAME} \
   -p BUSINESS_CENTRAL_HTTPS_NAME=jboss \
   -p KIE_SERVER_HTTPS_NAME=jboss \
   -p BUSINESS_CENTRAL_HTTPS_PASSWORD=${BUS_CENTRAL_PASSWORD} \
   -p KIE_SERVER_HTTPS_PASSWORD=${PROC_SERVER_PASSWORD} 
