#!/bin/bash

. .env

cat << EOF > ecodatum-ios-client/Secrets.swift
// Generated `date`

import Foundation

let ECODATUM_SCHEME = "$ECODATUM_SCHEME"
let ECODATUM_PORT = "$ECODATUM_PORT"
let ECODATUM_HOST = "$ECODATUM_HOST"
let ECODATUM_BASE_URL = URL(string: "\(ECODATUM_SCHEME)://\(ECODATUM_HOST):\(ECODATUM_PORT)")!
let ECODATUM_BASE_API_URL = ECODATUM_BASE_URL.appendingPathComponent("api")
let ECODATUM_BASE_V1_API_URL = ECODATUM_BASE_API_URL.appendingPathComponent("v1")

let SWIFTY_BEAVER_APP_ID = "$SWIFTY_BEAVER_APP_ID"
let SWIFTY_BEAVER_APP_SECRET = "$SWIFTY_BEAVER_APP_SECRET"
let SWIFTY_BEAVER_ENCRYPTION_KEY = "$SWIFTY_BEAVER_ENCRYPTION_KEY"

EOF