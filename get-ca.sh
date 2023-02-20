#! /bin/sh

route=$(oc get route | grep simple-rsyslog | awk '{print $2}')

mkdir -p certs

cd certs
openssl s_client -showcerts -connect $route:443 \
      -servername $route < /dev/null \
      | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/{ if(/BEGIN CERTIFICATE/){a++}; out="cert"a".pem"; print >out}'
for cert in *.pem; do
   newname=$(openssl x509 -noout -subject -in $cert | sed -nE 's/.*CN ?= ?(.*)/\1/; s/[ ,.*]/_/g; s/__/_/g; s/_-_/-/; s/^_//g;p' | tr '[:upper:]' '[:lower:]').pem
   mv $cert $newname
done

mv openshift-service-serving-signer@*.pem service-ca.pem

cd ..
