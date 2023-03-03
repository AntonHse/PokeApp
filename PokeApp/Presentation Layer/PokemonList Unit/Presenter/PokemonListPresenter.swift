import UIKit

protocol PokemonListPresenterProtocol {
    func presentPokemons(data: [Pokemon])
    func presentMorePokemons(data: [Pokemon])
    func presentPokemonDetailedData(_ data: Pokemon)
    
    func presentLoader()
    func hideLoader()
    
    func hideTopLoader()
    func hideBottomLoader()
}

final class PokemonListPresenter: PokemonListPresenterProtocol {
    
    // MARK: - Public Properties
    weak var viewController: (PokemonListVCProtocol & LoadingProtocol)?
    
    // MARK: - Private Properties
    private let imageStorage: ImageCacheStorageProtocol
    
    // MARK: - Init
    init(imageStorage: ImageCacheStorageProtocol) {
        self.imageStorage = imageStorage
    }
    
    // MARK: - Public Methods
    func presentPokemons(data: [Pokemon]) {
        let cellModels = configurePokemonModels(data: data)
        viewController?.dispayCells(models: cellModels)
    }
    
    func presentMorePokemons(data: [Pokemon]) {
        let cellModels = configurePokemonModels(data: data)
        viewController?.appendCells(models: cellModels)
    }
    
    func presentPokemonDetailedData(_ data: Pokemon) {
        imageStorage.loadImage(id: data.id, urlString: data.details?.sprite.url) { [weak self] image in
            guard let image = image else { return }
            self?.viewController?.updateCell(
                model: PokemonCellModel(id: data.id, image: image, placeholderImage: UIImage(named: "pokeball16"), name: data.name)
            )
        }
    }
    
    func presentLoader() {
        viewController?.startLoading()
    }
    
    func hideLoader() {
        viewController?.stopLoading()
    }
    
    func hideTopLoader() {
        viewController?.hideTopRefreshControll()
    }
    
    func hideBottomLoader() {
        viewController?.hideBottomRefreshControll()
    }
}

// MARK: - Private Methods
private extension PokemonListPresenter {
    func configurePokemonModels(data: [Pokemon]) -> [PokemonCellModel] {
        return data.map {
            PokemonCellModel(
                id: $0.id,
                image: imageStorage.getFromCache(id: $0.id),
                placeholderImage: UIImage(named: "pokeball16"),
                name: $0.name
            )
        }
    }
}
