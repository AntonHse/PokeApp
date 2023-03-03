import Foundation

protocol PokemonListResponseProtocol {
    var totalCount: Int { get }
    var nextUrl: URL { get }
    var pokemons: [PokemonPreview] { get }
}

struct PokemonListResponse: Decodable, PokemonListResponseProtocol {
    let totalCount: Int
    let nextUrl: URL
    let pokemons: [PokemonPreview]

    // MARK: - Init
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try values.decode(Int.self, forKey: .totalCount)
        nextUrl = try values.decode(URL.self, forKey: .nextUrl)
        pokemons = try values.decode([PokemonPreview].self, forKey: .pokemonsDetails)
    }
}

// MARK: - Private
private extension PokemonListResponse {
    enum CodingKeys: String, CodingKey {
        case totalCount = "count"
        case nextUrl = "next"
        case pokemonsDetails = "results"
    }
}
