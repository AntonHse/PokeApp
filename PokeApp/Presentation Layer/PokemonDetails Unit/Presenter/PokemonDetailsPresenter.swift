//
//  PokemonDetailsPresenter.swift
//  PokeApp
//
//  Created by Anton Shupletsov on 01.03.2023.
//

import Foundation

protocol PokemonDetailsPresenterProtocol {
    func presentNavBarTitle(title: String)
    func presentPokemonDetails(_ pokemon: PokemonDetails)
    
    func presentLoader()
    func hideLoader()
}

final class PokemonDetailsPresenter: PokemonDetailsPresenterProtocol {
    weak var viewController: PokemonDetailsVC?
    
    // MARK: - Private Properties
    private let imageStorage: ImageCacheStorageProtocol
    
    // MARK: - Init
    init(imageStorage: ImageCacheStorageProtocol) {
        self.imageStorage = imageStorage
    }
    
    // MARK: - Public Methods
    func presentNavBarTitle(title: String) {
        viewController?.setNavBarTitle(title)
    }
    
    func presentPokemonDetails(_ pokemon: PokemonDetails) {
        print(pokemon)
        imageStorage.loadImage(id: String(pokemon.id), urlString: pokemon.sprite.url) { [weak self] image in
            self?.hideLoader()
            self?.viewController?.dispayCells(models: [
                PokemonProfileCellModel(
                    image: image,
                    weightModel: (title: "Weight", description: "\(String(pokemon.weight)) kg"),
                    heightModel: (title: "Height", description: "\(String(pokemon.height)) m"),
                    typeModels: pokemon.types.compactMap { $0.type.name }
                )
            ])
        }
    }
    
    func presentLoader() {
        viewController?.startLoading()
    }
    
    func hideLoader() {
        viewController?.stopLoading()
    }
}
