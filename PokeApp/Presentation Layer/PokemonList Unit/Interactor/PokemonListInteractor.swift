import Foundation

final class PokemonListInteractor {
    
    private let presenter: PokemonListPresenter
    private let service: PokemonListService
    
    // MARK: - Init
    init(presenter: PokemonListPresenter, service: PokemonListService) {
        self.presenter = presenter
        self.service = service
    }
}
