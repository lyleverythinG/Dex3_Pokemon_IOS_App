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
    @State var showShiny = false
    
    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                
                AsyncImage(url:showShiny ? pokemon.shiny :  pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack {
                ForEach(pokemon.types!, id: \.self) {type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading,.trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Button {
                        showShiny.toggle()
                    } label: {
                        if showShiny {
                            Image(systemName: "wand.and.stars")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "wand.and.stars.inverse")
                        }
                    }
                } label: {
                    
                }
            }
        }
    }
}

#Preview {
    return PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
