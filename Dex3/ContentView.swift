//
//  ContentView.swift
//  Dex3
//
//  Created by Lyle Dane Carcedo on 12/9/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default
    ) private var pokedex: FetchedResults<Pokemon>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    ) private var favorites: FetchedResults<Pokemon>
    
    @State var filterByFavorites = false
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    var body: some View {
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                List(filterByFavorites ? favorites : pokedex) { pokemon in
                    NavigationLink(value: pokemon){
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)
                        
                        Text(pokemon.name!.capitalized)
                        
                        if pokemon.favorite {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self, destination: { pokemon in
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavorites.toggle()
                            }
                        } label: {
                            Image(systemName: filterByFavorites ? "star.fill" : "star")
                                .foregroundStyle(.yellow)
                        }
                        .font(.title)
                    }
                }
            }
        case  .fetching: ProgressView("Loading Pokemon...")
        case .failed (let error):
            VStack {
                Text("Failed to load Pokémon: \(error.localizedDescription)")
                    .foregroundStyle(.red)
            }
        case .notStarted:
            ProgressView("Starting")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
