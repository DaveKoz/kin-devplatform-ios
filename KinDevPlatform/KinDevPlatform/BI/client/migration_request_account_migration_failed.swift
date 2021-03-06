// Please help improve quicktype by enabling anonymous telemetry with:
//
//   $ quicktype --telemetry enable
//
// You can also enable telemetry on any quicktype invocation:
//
//   $ quicktype pokedex.json -o Pokedex.cs --telemetry enable
//
// This helps us improve quicktype by measuring:
//
//   * How many people use quicktype
//   * Which features are popular or unpopular
//   * Performance
//   * Errors
//
// quicktype does not collect:
//
//   * Your filenames or input data
//   * Any personally identifiable information (PII)
//   * Anything not directly related to quicktype's usage
//
// If you don't want to help improve quicktype, you can dismiss this message with:
//
//   $ quicktype --telemetry disable
//
// For a full privacy policy, visit app.quicktype.io/privacy
//

import Foundation

/// When the migration failed
struct MigrationRequestAccountMigrationFailed: KBIEvent {
    let client: Client
    let common: Common
    let errorCode, errorMessage, errorReason: String
    let eventName: String
    let eventType: String
    let publicAddress: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case client, common
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case errorReason = "error_reason"
        case eventName = "event_name"
        case eventType = "event_type"
        case publicAddress = "public_address"
        case user
    }
}

extension MigrationRequestAccountMigrationFailed {
    init(errorCode: String, errorMessage: String, errorReason: String, publicAddress: String) throws {
        let es = EventsStore.shared

        guard   let user = es.userProxy?.snapshot,
                let common = es.commonProxy?.snapshot,
                let client = es.clientProxy?.snapshot else {
                throw BIError.proxyNotSet
        }

        self.user = user
        self.common = common
        self.client = client

        eventName = "migration_request_account_migration_failed"
        eventType = "log"

        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.errorReason = errorReason
        self.publicAddress = publicAddress
    }
}
