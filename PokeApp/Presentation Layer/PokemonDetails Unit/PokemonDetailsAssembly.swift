import UIKit

final class PokemonDetailsAssembly {

    static func build(pokemonID: String) -> UIViewController {
        let networkClient = NetworkClient()
        let service = PokemonService(networkClient: networkClient)

        let presenter = PokemonDetailsPresenter(imageStorage: ImageCacheStorage.shared)
        let interactor = PokemonDetailsInteractor(presenter: presenter,
                                                  service: service,
                                                  storage: PokemonCacheStorage.shared,
                                                  pokemonID: pokemonID)
        let viewController = PokemonDetailsVC(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
    
    // MARK: - Private Init
    private init() {}
}
