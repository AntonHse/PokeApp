//
//  PokemonDetailsInteractor.swift
//  PokeApp
//
//  Created by Anton Shupletsov on 01.03.2023.
//

import Foundation

protocol PokemonDetailsInteractorProtocol {
    func setupInitialData()
}

final class PokemonDetailsInteractor {
    
    // MARK: - Private Properties
    private let presenter: PokemonDetailsPresenterProtocol
    private let service: PokemonServiceProtocol
    private let storage: PokemonCacheStorageProtocol
    
    private let pokemonID: String
    
    // MARK: - Init
    init(
        presenter: PokemonDetailsPresenterProtocol,
        service: PokemonServiceProtocol,
        storage: PokemonCacheStorageProtocol,
        pokemonID: String
    ) {
        self.presenter = presenter
        self.service = service
        self.storage = storage
        self.pokemonID = pokemonID
    }
    
    // MARK: - Public Methods
    func setupInitialData() {
        guard let pokemon = storage.get(for: pokemonID) else { return }
        
        presenter.presentLoader()
        presenter.presentNavBarTitle(title: pokemon.name)
        if let pokemonDetails = pokemon.details {
            presenter.presentPokemonDetails(pokemonDetails)
        } else {
            service.fetchPokemonDetails(id: pokemonID) { [weak self] result in
                self?.presenter.hideLoader()
    
                switch result {
                case .success(let response):
                    pokemon.details = response

                    self?.storage.save(pokemon: pokemon)
                    self?.presenter.presentPokemonDetails(response)
                    
                case .failure(let error):
                    print("TODO: Handle Error \(error)")
                }
            }
        }
    }
}
