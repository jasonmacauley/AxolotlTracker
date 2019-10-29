#!/bin/bash

set -e

rm -f /sbapp/tmp/pids/sever.pid

exec "$@"
