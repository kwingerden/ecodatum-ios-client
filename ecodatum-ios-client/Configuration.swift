// Generated Wed Jan 10 13:00:56 PST 2018

import Foundation

let ECODATUM_SCHEME = "https"
let ECODATUM_PORT = "443"
let ECODATUM_HOST = "www.ecodatum.org"
let ECODATUM_BASE_URL = URL(string: "\(ECODATUM_SCHEME)://\(ECODATUM_HOST):\(ECODATUM_PORT)")!
let ECODATUM_BASE_API_URL = ECODATUM_BASE_URL.appendingPathComponent("api")
let ECODATUM_BASE_V1_API_URL = ECODATUM_BASE_API_URL.appendingPathComponent("v1")

let SWIFTY_BEAVER_APP_ID = "pgxJOG"
let SWIFTY_BEAVER_APP_SECRET = "u0ex2m3fhdmSdwzAwsxahqzZq91x2orE"
let SWIFTY_BEAVER_ENCRYPTION_KEY = "nruP7Yf0zgFhyzjv63wygYreZUsXln27"

let ECODATUM_DATABASE_FILE_NAME = "ecodatum.sqlite"

let DROP_AND_RECREATE_ECODATUM_DATABASE_FILE = true

