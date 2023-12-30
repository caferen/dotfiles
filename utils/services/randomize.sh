#!/bin/bash

/usr/bin/macchanger -e wlp0s20f3

echo "b08dfa6083e7567a1921a715000001fb" | tee /var/lib/dbus/machine-id
echo "b08dfa6083e7567a1921a715000001fb" | tee /etc/machine-id
