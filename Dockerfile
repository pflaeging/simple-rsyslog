FROM default-route-openshift-image-registry.apps.a2.cp.cna.at/cp-baseimages/brz-cp-ubi8-ubi-minimal:latest

LABEL summary="Simple RSyslog" \
      description="Simple RSyslog container" \
      io.k8s.description="Simple RSyslog Container" \
      io.k8s.display-name="Simple RSyslog" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="simple-rsyslog" \
      name="paascpp/simple-rsyslog" \
      version="1.0" \
      maintainer="Peter Pfläging <peter@pflaeging.net>"

RUN  microdnf -y install rsyslog && \
	 microdnf clean all && \
     rm -rf /var/cache/yum

RUN chgrp -R 0 /var/lib/rsyslog && \
    chmod -R g+rwX /var/lib/rsyslog && \
    chgrp -R 0 /var/log && \
    chmod -R g+rwX /var/log

COPY rsyslog.conf /etc/rsyslog.conf

EXPOSE 10514
USER 1001
CMD ["sh", "-c", "/usr/sbin/rsyslogd -i /tmp/rsyslog.pid -n -f /etc/rsyslog.conf"]
