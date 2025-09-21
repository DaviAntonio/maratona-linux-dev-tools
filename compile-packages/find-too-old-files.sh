#!/bin/env bash

find "$1" -type f -not -newermt "@$(date --date='1984-01-01' '+%s')"
