//
//  PokemonLisSpies.swift
//  PokeAppTests
//
//  Created by Anton Shupletsov on 02.03.2023.
//

@testable import PokeApp
import Foundation

final class PokemonListPresenterSpy: PokemonListPresenterProtocol {
    
    private(set) var presentPokemonsInvoked = false
    private(set) var presentMorePokemonsInvoked = false
    private(set) var presentPokemonDetailedDataInvoked = false
    private(set) var presentLoaderInvoked = false
    private(set) var hideLoaderInvoked = false
    private(set) var hideTopLoaderInvoked = false
    private(set) var hideBottomLoaderInvoked = false
    
    func presentPokemons(data: [PokeApp.Pokemon]) {
        presentPokemonsInvoked = true
    }
    
    func presentMorePokemons(data: [PokeApp.Pokemon]) {
        presentMorePokemonsInvoked = true
    }
    
    func presentPokemonDetailedData(_ data: PokeApp.Pokemon) {
        presentPokemonDetailedDataInvoked = true
    }
    
    func presentLoader() {
        presentLoaderInvoked = true
    }
    
    func hideLoader() {
        hideLoaderInvoked = true
    }
    
    func hideTopLoader() {
        hideTopLoaderInvoked = true
    }
    
    func hideBottomLoader() {
        hideBottomLoaderInvoked = true
    }
}

final class PokemonServiceSpy: PokemonServiceProtocol {
    
    var fetchPokemonsSucceed = true
    private(set) var fetchPokemonsInvoked = false
    private(set) var fetchPokemonDetailsInvoked = false
    private(set) var uploadPokemonsInvoked = false

    func fetchPokemons(completion: @escaping (Result<PokeApp.PokemonListResponseProtocol, PokeApp.NetworkErrors>) -> Void) {
        fetchPokemonsInvoked = true
        
        if fetchPokemonsSucceed {
            completion(Result<PokeApp.PokemonListResponseProtocol, PokeApp.NetworkErrors>.success(PokemonListResponseMock()))
        } else {
            completion(Result<PokeApp.PokemonListResponseProtocol, PokeApp.NetworkErrors>.failure(NetworkErrors.default))
        }
    }
    
    func fetchPokemonDetails(id: String, completion: @escaping (Result<PokeApp.PokemonDetails, PokeApp.NetworkErrors>) -> Void) {
        fetchPokemonDetailsInvoked = true
    }
    
    func uploadPokemons(offset: String, limit: String, completion: @escaping (Result<PokeApp.PokemonListResponseProtocol, PokeApp.NetworkErrors>) -> Void) {
        uploadPokemonsInvoked = true
    }
}

final class PokemonCacheStorageSpy: PokemonCacheStorageProtocol {
    
    private(set) var savePokemonsInvoked = false
    private(set) var savePokemonInvoked = false
    private(set) var getPokemonInvoked = false
    private(set) var clearInvoked = false
    
    func save(pokemons: [PokeApp.Pokemon]) {
        savePokemonsInvoked = true
    }
    
    func save(pokemon: PokeApp.Pokemon) {
        savePokemonInvoked = true
    }
    
    func get(for id: String) -> PokeApp.Pokemon? {
        getPokemonInvoked = true
        return nil
    }
    
    func clear() {
        clearInvoked = true
    }
}

struct PokemonListResponseMock: PokemonListResponseProtocol {
    var totalCount: Int = 0
    var nextUrl: URL = URL(string: "https://pokeapi.co")!
    var pokemons: [PokeApp.PokemonPreview] = [
        PokemonPreview(name: "", detailsUrl: URL(string: "https://pokeapi.co")!)
    ]
}
