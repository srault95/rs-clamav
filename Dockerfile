FROM rs/base-image:xenial

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	bzip2 \
	clamav \
	clamav-daemon \
	clamdscan \
	clamav-unofficial-sigs

ADD clamd.conf /etc/clamav/
ADD freshclam.conf /etc/clamav/
RUN mkdir /etc/service/clamd /etc/service/freshclam
ADD clamd.sh /etc/service/clamd/run
ADD freshclam.sh /etc/service/freshclam/run

RUN chmod +x /etc/service/clamd/run /etc/service/freshclam/run

VOLUME ["/var/run/clamav", "/var/lib/clamav"}

EXPOSE 3310

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
