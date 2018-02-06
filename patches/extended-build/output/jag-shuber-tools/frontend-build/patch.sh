#!/usr/bin/env bash

oc export bc/frontend-build -o json -n jag-shuber-tools > frontend-build-backup.json
oc patch --local=true -f frontend-build-backup.json --type="json" -o json --patch='[   {     "op": "replace",     "path": "/spec/source",     "value": {       "type": "Dockerfile",       "dockerfile": "FROM angular-app:latest\nCOPY * /tmp/app/dist/\nCMD  /usr/libexec/s2i/run",       "images": [         {           "from": {             "kind": "ImageStreamTag",             "name": "angular-app:latest"           },           "paths": [             {               "sourcePath": "/opt/app-root/src/dist/.",               "destinationDir": "tmp"             }           ]         }       ]     }   },   {     "op": "replace",     "path": "/spec/strategy",     "value": {       "type": "Docker",       "dockerStrategy": {         "from": {           "kind": "ImageStreamTag",           "namespace": "openshift",           "name": "nginx-runtime:latest"         }       }     }   } ]' > frontend-build-patched.json