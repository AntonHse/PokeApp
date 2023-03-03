import Foundation

/// Network errors
enum NetworkErrors: Error {
    case decodingError                      // Failed on decoded from data
    case jsonConvertingFailed               // Failed converting from json to data
    case describing(Error)                  // Error with Description
    case `default`                          // Default Error
}

struct GitlabAuthError: Decodable {
    let errorType: ErrorDataType
    let description: String

    // MARK: - Init
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorType = try values.decode(ErrorDataType.self, forKey: .errorType)
        description = try values.decode(String.self, forKey: .description)
    }
    
    enum ErrorDataType: String, Decodable {
        case authorizationPending = "authorization_pending"
        case slowDown = "slow_down"
        case expiredToken = "expired_token"
        case unsupportedGrantType = "unsupported_grant_type"
        case incorrectClientCredentials = "incorrect_client_credentials"
        case incorrectDeviceCode = "incorrect_device_code"
        case accessDenied = "accessDenied"
        case deviceFlowDisabled = "deviceFlowDisabled"
    }
}

// MARK: - Private
private extension GitlabAuthError {
    enum CodingKeys: String, CodingKey {
        case description = "error_description"
        case errorType = "error"
    }
}
