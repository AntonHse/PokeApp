import Foundation

final class PokemonListService {

    // MARK: - Private Properties
    private let networkClient: NetworkClientProtocol
    
    // MARK: - Init
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
}
