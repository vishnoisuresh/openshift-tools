#!/bin/bash
#
# Patch CNS block/file quotas for all "user" projects that do not have a "custom_quota=true" label)
#
for P in $(oc get projects -l 'project_type=user,custom_quota!=true' -o=custom-columns=NAME:.metadata.name --no-headers);
do 
  echo $P; 
  Q=$(oc -n $P get quota -o name);
  if [ -n "$Q" ]
  then
    oc -n $P patch $Q -p '
{
  "spec": {
    "hard": {
      "persistentvolumeclaims": 20,
      "requests.storage": "200Gi",
      "gluster-file.storageclass.storage.k8s.io/persistentvolumeclaims": 20,
      "gluster-file.storageclass.storage.k8s.io/requests.storage": "200Gi",
      "gluster-file-db.storageclass.storage.k8s.io/persistentvolumeclaims": 20,
      "gluster-file-db.storageclass.storage.k8s.io/requests.storage": "200Gi",
      "gluster-block.storageclass.storage.k8s.io/persistentvolumeclaims": 20,
      "gluster-block.storageclass.storage.k8s.io/requests.storage": "200Gi"
    }
  }
}';
  fi
done
