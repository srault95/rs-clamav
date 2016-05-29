#!/bin/sh

mkdir -p /var/run/clamav
chown clamav.clamav -R /var/run/clamav
chown clamav.clamav -R /var/lib/clamav

exec clamd
