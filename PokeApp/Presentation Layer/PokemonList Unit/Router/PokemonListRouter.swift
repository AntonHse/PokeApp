import UIKit

protocol PokemonListRouterProtocol {
    func routeToPokemonScreen(pokemonID: String)
}

final class PokemonListRouter: PokemonListRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func routeToPokemonScreen(pokemonID: String) {
        let pokemonDetailsVC = PokemonDetailsAssembly.build(pokemonID: pokemonID)

        let navController = UINavigationController(rootViewController: pokemonDetailsVC)
        viewController?.present(navController, animated: true)
    }
}
