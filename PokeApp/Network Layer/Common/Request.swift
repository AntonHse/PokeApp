import Foundation

typealias Parameters = [String: Any]

// MARK: - Public Enums

/// Default response to a compliment block
enum ResultDefault {
    case success
    case failure(_ error: NetworkErrors)
}

/// http request types
enum HTTPRequestType {
    case `default`
    case urlParameters(_ parameters: [String: String], encodeType: CharacterSet? = nil)
    case bodyParameters(_ parameters: Parameters)
    case image(imagePath: String, encodeType: CharacterSet? = nil)
}

struct Credentionals {
    let username: String
    let password: String
}

protocol RequestProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var type: HTTPRequestType { get }
    var headers: [String: String] { get }
}

final class Request<Response: Decodable>: RequestProtocol {

    // MARK: - Public Methods
    let baseURL: URL

    let path: String

    let httpMethod: HTTPMethod

    let type: HTTPRequestType
    
    var headers: [String: String]
    
    let authorizationCredentionals: Credentionals?

    // MARK: - Init
    init(
        baseURL: URL = Domains.pokeApi,
        path: String,
        type: HTTPRequestType = .default,
        httpMethod: HTTPMethod = .get,
        headers: [String: String] = [:],
        authorizationCredentionals: Credentionals? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.httpMethod = httpMethod
        self.type = type
        self.headers = headers
        self.authorizationCredentionals = authorizationCredentionals
    }
}
