#!/bin/bash

. .env

cat << EOF > ecodatum-ios-client/Secrets.swift
// Generated `date`

import Foundation

let ECODATUM_BASE_URL = URL(string: "$ECODATUM_BASE_URL")!

let SWIFTY_BEAVER_APP_ID = "$SWIFTY_BEAVER_APP_ID"
let SWIFTY_BEAVER_APP_SECRET = "$SWIFTY_BEAVER_APP_SECRET"
let SWIFTY_BEAVER_ENCRYPTION_KEY = "$SWIFTY_BEAVER_ENCRYPTION_KEY"

EOF