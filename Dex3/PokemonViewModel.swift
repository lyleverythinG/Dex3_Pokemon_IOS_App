//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Lyle Dane Carcedo on 12/11/24.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private var controller = FetchController()
    
    init(controller: FetchController) {
        self.controller = controller
        
        Task {
            await getPokemon()
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        print("Fetching Pokémon data...")
        
        do {
            guard var pokedex = try await controller.fetchAllPokemon() else {
                print ("Pokemon already exist")
                status = .success
                return
            }
            
            pokedex.sort { $0.id < $1.id }
            
            let viewContext = PersistenceController.shared.container.viewContext
            
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.organizeTypes()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
            }
            
            try viewContext.save()
            print("Data successfully saved to Core Data.")
            
            status = .success
        } catch {
            print("Error fetching or saving Pokémon: \(error.localizedDescription)")
            status = .failed(error: error)
        }
    }
}
