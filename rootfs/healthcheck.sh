#!/bin/sh
s6-svstat /run/s6-rc/servicedirs/hiddify || exit 1
s6-svstat /run/s6-rc/servicedirs/socks-to-http-proxy || exit 1