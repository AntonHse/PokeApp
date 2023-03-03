import UIKit

protocol PokemonServiceProtocol {
    func fetchPokemons(completion: @escaping (Result<PokemonListResponseProtocol, NetworkErrors>) -> Void)
    func fetchPokemonDetails(id: String, completion: @escaping (Result<PokemonDetails, NetworkErrors>) -> Void)
    func uploadPokemons(offset: String, limit: String, completion: @escaping (Result<PokemonListResponseProtocol, NetworkErrors>) -> Void)
}

final class PokemonService: PokemonServiceProtocol {

    // MARK: - Private Properties
    private let networkClient: NetworkClientProtocol
    
    // MARK: - Init
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    // MARK: - PokemonListServiceProtocol
    func fetchPokemons(completion: @escaping (Result<PokemonListResponseProtocol, NetworkErrors>) -> Void) {
        let request = Request<PokemonListResponse>(
            path: "pokemon",
            httpMethod: .get
        )

        networkClient.sendRequest(request: request) { result in
            switch result {
            case .success(let response):
                guard let response = response as? PokemonListResponseProtocol else {
                    completion(.failure(.default))
                    return
                }
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPokemonDetails(id: String, completion: @escaping (Result<PokemonDetails, NetworkErrors>) -> Void) {
        let request = Request<PokemonDetails>(
            path: "pokemon/\(id)",
            httpMethod: .get
        )
        if Int(id) ?? 0 >= 899 {
            print("Bug")
        }
        
        networkClient.sendRequest(request: request) { result in
            switch result {
            case .success(let response):
                guard let response = response as? PokemonDetails else {
                    completion(.failure(.default))
                    return
                }
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadPokemons(offset: String, limit: String, completion: @escaping (Result<PokemonListResponseProtocol, NetworkErrors>) -> Void) {
        let parameters: [String: String] = [Keys.limit.rawValue: limit,
                                            Keys.offset.rawValue: offset]
        
        let request = Request<PokemonListResponse>(
            path: "pokemon",
            type: .urlParameters(parameters),
            httpMethod: .get
        )

        networkClient.sendRequest(request: request) { result in
            switch result {
            case .success(let response):
                guard let response = response as? PokemonListResponseProtocol else {
                    completion(.failure(.default))
                    return
                }
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Private Keys
extension PokemonService {
    enum Keys: String {
        case limit
        case offset
    }
}
