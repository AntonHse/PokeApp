import UIKit

final class PokemonListAssembly {

    static func build() -> UIViewController {
        let networkClient = NetworkClient()
        let service = PokemonListService(networkClient: networkClient)

        let presenter = PokemonListPresenter()
        let interactor = PokemonListInteractor(presenter: presenter, service: service)
        let viewController = PokemonListVC(interactor: interactor)
        
        presenter.viewController = viewController
        
        return viewController
    }
    
    // MARK: - Private Init
    private init() {}
}
