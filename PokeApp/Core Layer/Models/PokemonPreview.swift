import Foundation

struct PokemonPreview: Decodable {
    let name: String
    let detailsUrl: URL

    // MARK: - Init
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        detailsUrl = try values.decode(URL.self, forKey: .detailsUrl)
    }
    
    init(name: String, detailsUrl: URL) {
        self.name = name
        self.detailsUrl = detailsUrl
    }
}

// MARK: - Private
private extension PokemonPreview {
    enum CodingKeys: String, CodingKey {
        case name
        case detailsUrl = "url"
    }
}
