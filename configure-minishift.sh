#/bin/bash

# create profile
minishift profile set rhpamauthenv

# install admin add on
# this allows the pam product containers to be installed in the openshift space
minishift addons install --defaults
minishift addons enable admin-user
minishift addon list

# start minishift and setup oc binary
minishift start
eval $(minishift oc-env)
