import UIKit

final class PokemonListAssembly {

    static func build() -> UIViewController {
        let networkClient = NetworkClient()
        let service = PokemonService(networkClient: networkClient)

        let router = PokemonListRouter()
        let presenter = PokemonListPresenter(imageStorage: ImageCacheStorage.shared)
        let interactor = PokemonListInteractor(presenter: presenter, service: service, storage: PokemonCacheStorage.shared)
        let viewController = PokemonListVC(interactor: interactor, router: router)
        
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
    
    // MARK: - Private Init
    private init() {}
}
