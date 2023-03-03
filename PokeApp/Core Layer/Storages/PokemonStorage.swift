//
//  PokemonStorage.swift
//  PokeApp
//
//  Created by Anton Shupletsov on 01.03.2023.
//

import Foundation

protocol PokemonCacheStorageProtocol {
    func save(pokemons: [Pokemon])
    func save(pokemon: Pokemon)
    func get(for id: String) -> Pokemon?
    func clear()
}

final class PokemonCacheStorage: PokemonCacheStorageProtocol {
    
    static let shared: PokemonCacheStorageProtocol = PokemonCacheStorage()
    
    // MARK: - Private Properties
    private var pokemons: [String: Pokemon] = [:]
    
    // MARK: - Init
    private init() {}
    
    // MARK: - Public Methods
    func save(pokemons: [Pokemon]) {
        pokemons.forEach { save(pokemon: $0) }
    }
    
    func save(pokemon: Pokemon) {
        pokemons[pokemon.id] = pokemon
    }

    func get(for id: String) -> Pokemon? {
        return pokemons[id]
    }
    
    func clear() {
        pokemons.removeAll()
    }
}
