import Foundation

protocol PokemonListInteractorProtocol {
    func setupInitialData()
    func reload()
    func loadMorePokemons()
}

final class PokemonListInteractor: PokemonListInteractorProtocol {
    
    private let storage: PokemonCacheStorageProtocol
    private let presenter: PokemonListPresenterProtocol
    private let service: PokemonServiceProtocol
    
    private var pokemons: [Pokemon] = []
    private var nextPage: (offset: String, limit: String) = ("", "")
    
    // MARK: - Init
    init(presenter: PokemonListPresenterProtocol, service: PokemonServiceProtocol, storage: PokemonCacheStorageProtocol) {
        self.presenter = presenter
        self.service = service
        self.storage = storage
    }
    
    // MARK: - Public Methods

    
    func setupInitialData() {
        presenter.presentLoader()
        
        service.fetchPokemons { [weak self] result in
            guard let self = self else { return }
            self.presenter.hideLoader()
            
            switch result {
            case .success(let response):
                self.pokemons = self.castPokemons(response.pokemons)
                let queryParametrs = response.nextUrl.queryParameters()
                
                self.nextPage = (
                    offset: queryParametrs[PokemonService.Keys.offset.rawValue] ?? "",
                    limit: queryParametrs[PokemonService.Keys.limit.rawValue] ?? ""
                )

                self.storage.save(pokemons: self.pokemons)
                self.presenter.presentPokemons(data: self.pokemons)
                self.fetchPokemonsDetails(pokemons: self.pokemons)
                
            case .failure(let error):
                print("TODO: Handle Error \(error)")
            }
        }
    }
    
    func reload() {
        service.fetchPokemons { [weak self] result in
            guard let self = self else { return }
            self.presenter.hideTopLoader()
            
            switch result {
            case .success(let response):
                self.pokemons = self.castPokemons(response.pokemons)
                let queryParametrs = response.nextUrl.queryParameters()
                
                self.nextPage = (
                    offset: queryParametrs[PokemonService.Keys.offset.rawValue] ?? "",
                    limit: queryParametrs[PokemonService.Keys.limit.rawValue] ?? ""
                )

                self.storage.clear()
                self.storage.save(pokemons: self.pokemons)
                self.presenter.presentPokemons(data: self.pokemons)
                self.fetchPokemonsDetails(pokemons: self.pokemons)
                
            case .failure(let error):
                print("TODO: Handle Error \(error)")
            }
        }
    }
    
    func loadMorePokemons() {
        service.uploadPokemons(offset: nextPage.offset, limit: nextPage.limit) { [weak self] result in
            guard let self = self else { return }
            self.presenter.hideBottomLoader()
    
            switch result {
            case .success(let response):
                let newPokemons = self.castPokemons(response.pokemons)
                self.pokemons += newPokemons
                let queryParametrs = response.nextUrl.queryParameters()
                
                self.nextPage = (
                    offset: queryParametrs[PokemonService.Keys.offset.rawValue] ?? "",
                    limit: queryParametrs[PokemonService.Keys.limit.rawValue] ?? ""
                )

                self.storage.save(pokemons: newPokemons)
                self.presenter.presentMorePokemons(data: newPokemons)
                self.fetchPokemonsDetails(pokemons: newPokemons)

            case .failure(let error):
                print("TODO: Handle Error \(error)")
            }
        }
    }
}

// MARK: - Private Methods
private extension PokemonListInteractor {
    func fetchPokemonsDetails(pokemons: [Pokemon]) {
        pokemons.forEach { fetchPokemonDetails(pokemon: $0) }
    }
    
    func fetchPokemonDetails(pokemon: Pokemon, counter: Int = 0) {
        guard pokemon.details == nil else { return }
        
        service.fetchPokemonDetails(id: pokemon.id) { [weak self] result in
            switch result {
            case .success(let response):
                pokemon.details = response

                self?.storage.save(pokemon: pokemon)
                self?.presenter.presentPokemonDetailedData(pokemon)
                
            case .failure(let error):
                guard counter <= 2 else { return }
                self?.fetchPokemonDetails(pokemon: pokemon, counter: counter + 1)
                print("TODO: Handle Error \(error)")
            }
        }
    }
    
    func castPokemons(_ pokemonPreviews: [PokemonPreview]) -> [Pokemon] {
        return pokemonPreviews.map { Pokemon(id: $0.detailsUrl.lastPathComponent, name: $0.name) }
    }
}
