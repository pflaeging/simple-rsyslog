# Simple rsyslog container running in an OpenShift namespace

This container could be contacted:

- inside your namespace via TCP/1514 (service definition syslog)
- form outside via TLS and the created Openshift Route

The rsyslog container writes all his logging on stdout (means console log in kubernetes).

## Build

```shell
oc apply -k kustomize/build
```

## Deploy

Check your `kustomize/deploy/kustomization.yaml` for:

- right path for the imagestream

```shell
oc apply -k kustomize/deploy
```

## Test

You can test the function from a machine outside your cluster with:

```shell
echo "<142>$HOSTNAME Hello World, dodo" | gnutls-cli simple-rsyslog-mynamespace.apps.mycluster.cool --port=443 --insecure
```

## Client config

- There's a shellscript which gets the CA of the server for you: `sh ./get-ca.sh`
- copy the `certs/service-ca.pem` to your client machine in `/etc/certs/rsyslog-ca.pem`

The config should look like:

```config
global(
  DefaultNetstreamDriverCAFile="/etc/certs/rsyslog-ca.pem"
)
action(
  type="omfwd"
  protocol="tcp"
  target="simple-rsyslog-mynamespace.apps.mycluster.cool"
  port="443"
  StreamDriver="gtls"
  StreamDriverMode="1"
  StreamDriverAuthMode="anon"
  StreamDriverPermittedPeers="*.apps.mycluster.cool"
)
```

(this config is pretty untested right now)

---
Peter Pfläging <<peter@pflaeging.net>>