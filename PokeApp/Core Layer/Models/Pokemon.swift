import Foundation

final class Pokemon {
    let id: String
    let name: String
    var details: PokemonDetails?
    
    init(id: String, name: String, details: PokemonDetails? = nil) {
        self.id = id
        self.name = name
        self.details = details
    }
}
