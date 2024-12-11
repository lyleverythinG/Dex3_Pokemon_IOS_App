//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Lyle Dane Carcedo on 12/11/24.
//

import SwiftUI
import CoreData

struct PokemonDetail: View {
    @EnvironmentObject var pokemon: Pokemon
    
    var body: some View {
        Text("HELLO WORLD")
    }
}

#Preview {
    return PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
