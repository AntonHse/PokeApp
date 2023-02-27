import Foundation

protocol NetworkClientProtocol {
    /// Send network request
    ///
    /// - Parameters:
    ///   - request: request model
    ///   - completion: completion block
    func sendRequest<Response>(request: Request<Response>,
                               completion: @escaping (Result<Decodable, NetworkErrors>) -> Void)

    /// Build network request
    ///
    /// - Parameters:
    ///   - request: request model
    /// - Returns: Builded request
    func buildRequest<Response>(request: Request<Response>) -> URLRequest
}

final class NetworkClient {
    static let noResponseMessage = "Request without response"
    
    private let networkQueue = DispatchQueue(label: "com.pokeApp.networkqueue",
                                             attributes: .concurrent)
}

// MARK: - NetworkClientProtocol
extension NetworkClient: NetworkClientProtocol {
    
    func sendRequest<Response>(request: Request<Response>, completion: @escaping (Result<Decodable, NetworkErrors>) -> Void) where Response: Decodable {
        networkQueue.async { [weak self] in
            guard let self = self else { return }
            
            let urlRequest = self.buildRequest(request: request, completion: completion)
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    if let response = response as? HTTPURLResponse {
                        print(response.statusCode)
                    }
                    
                    if let error = error {
                        completion(.failure(NetworkErrors.describing(error)))
                        return
                    }

                    if case .image = request.type {
                        return completion(.success(data))
                    } else if let data = data, !data.isEmpty {
                        self.decodeData(request: request, data: data, completion: completion)
                    } else {
                        completion(.success(NetworkClient.noResponseMessage))
                    }
                }
            }.resume()
        }
    }
    
    func buildRequest<Response>(request: Request<Response>) -> URLRequest {
        return buildRequest(request: request) { _ in }
    }
}

// MARK: - Private Methods
private extension NetworkClient {
    
    func buildRequest<Response>(
        request: Request<Response>,
        completion: (Result<Decodable, NetworkErrors>) -> Void) -> URLRequest {
            // Path
            let urlPath = request.baseURL.appendingPathComponent(request.path)
            // Url request
            var urlRequest = URLRequest(url: urlPath,
                                        cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                        timeoutInterval: 15.0)
            
            // HTTP Method
            urlRequest.httpMethod = request.httpMethod.rawValue
            
            // Headers
            if !request.headers.isEmpty {
                request.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
            }
            
            // Authorization Header
            if let credentionals = request.authorizationCredentionals {
                urlRequest.setBasicAuth(username: credentionals.username, password: credentionals.password)
            }
            
            // Type
            switch request.type {
            case .default:
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                
            case let .urlParameters(parameters, encodeType):
                guard var urlComponents = URLComponents(url: urlPath, resolvingAgainstBaseURL: false),
                      !parameters.isEmpty else {
                    completion(.failure(NetworkErrors.default))
                    return urlRequest
                }
                
                var queryItems: [URLQueryItem] = []
                
                parameters.forEach { key, value in
                    let queryItem = URLQueryItem(name: key, value: value.encodeIfNeeded(to: encodeType))
                    queryItems.append(queryItem)
                }
                urlComponents.queryItems = queryItems
                urlRequest.url = urlComponents.url
                
            case .bodyParameters(let parameters):
                guard let body = try? JSONSerialization.data(withJSONObject: parameters,
                                                             options: .prettyPrinted) else {
                    print("Error encoding user data")
                    completion(.failure(NetworkErrors.jsonConvertingFailed))
                    return urlRequest
                }
                
                urlRequest.httpBody = body
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
                
            case let .image(imagePath, encodeType):
                let path = urlPath.appendingPathComponent(imagePath.encodeIfNeeded(to: encodeType))
                urlRequest.url = path
            }
            
            return urlRequest
        }
    
    func decodeData<Response>(request: Request<Response>,
                              data: Data,
                              completion: @escaping (Result<Decodable, NetworkErrors>) -> Void) {
        print(String(decoding: data, as: UTF8.self))
        guard let decode = try? JSONDecoder().decode(Response.self, from: data) else {
            completion(.failure(NetworkErrors.decodingError))
            return
        }
        completion(.success(decode))
    }
    
    func decodeErrorIfNeeded() {
        
    }
}

// MARK: - Private URLRequest + Extension
private extension URLRequest {
    mutating func setBasicAuth(username: String, password: String) {
        let encodedAuthInfo = String(format: "%@:%@", username, password)
            .data(using: String.Encoding.utf8)!
            .base64EncodedString()
        setValue("Basic \(encodedAuthInfo)", forHTTPHeaderField: "Authorization")
    }
}

// MARK: - Private String + Extension
private extension String {
    func encodeIfNeeded(to type: CharacterSet?) -> String {
        guard let type = type else { return self }
        return self.addingPercentEncoding(withAllowedCharacters: type) ?? self
    }
}
