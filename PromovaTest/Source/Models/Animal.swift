//
//  Animal.swift
//  PromovaTest
//
//  Created by Laslo on 20.05.2023.
//

import Foundation

struct Animal: Codable, Equatable, Hashable {
    
    enum Status: String, Codable, Hashable {
        case paid
        case free
        case comingSoon = "coming_soon"
    }
    
    struct Fact: Codable, Hashable {
        let fact: String
        let image: URL
    }
    
    // MARK: - Properties
    
    let title: String
    let description: String
    let image: URL
    let order: Int
    let status: Status
    let content: [Fact]?
    
    // MARK: - Static
    
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        lhs.title == rhs.title
    }
    
    static var mock: Self {
        return Animal(
            title: "MockAnimal",
            description: "MockDescription",
            image: URL(string: "https://cataas.com/cat")!,
            order: 0,
            status: .free,
            content: [
                Fact(fact: "First",
                     image: URL(string: "https://cataas.com/cat")!),
                Fact(fact: "Second",
                     image: URL(string: "https://cataas.com/cat")!),
                Fact(fact: "Third",
                     image: URL(string: "https://cataas.com/cat")!)
                
            ]
        )
    }
}
