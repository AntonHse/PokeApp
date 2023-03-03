//
//  PokemonDetails.swift
//  PokeApp
//
//  Created by Anton Shupletsov on 01.03.2023.
//

import Foundation

struct PokemonDetails: Decodable {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let baseExperience: Int?
    let sprite: Sprite
//    let abilities: [Ability]
//    let moves: [Move]
    let types: [PokemonType]
//    let stats: [Stat]

    // MARK: - Init
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        weight = try values.decode(Int.self, forKey: .weight)
        height = try values.decode(Int.self, forKey: .height)
        baseExperience = try? values.decode(Int.self, forKey: .baseExperience)
        sprite = try values.decode(Sprite.self, forKey: .sprites)
        types = try values.decode([PokemonType].self, forKey: .types)
    }
    
    struct Sprite: Decodable {
        let url: String

        private enum CodingKeys: String, CodingKey {
            case url = "front_default"
        }
    }
}

extension PokemonDetails {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case weight
        case height
        case abilities
        case moves
        case types
        case stats
        case baseExperience = "base_experience"
        case sprites
    }
}

struct PokemonType: Decodable {
    let type: BaseURL
}

struct BaseURL: Decodable {
    let name: String
    let url: String
}
