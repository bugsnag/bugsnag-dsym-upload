#!/bin/bash
curl https://raw.githubusercontent.com/bugsnag/license-audit/master/config/decision_files/global.yml -o config/global.yml
bundle install
license_finder --decisions-file=config/global.yml
