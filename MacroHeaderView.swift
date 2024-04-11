//
//  MecroItemView.swift
//  NutriMind
//
//  Created by Preeten Dali on 23/01/24.
//

import SwiftUI

struct MacroHeaderView: View {
    var carbs: Int
    var fats: Int
    var proteins: Int
    var body: some View {
        HStack {
            
            Spacer()
            
            VStack {
                Image("carbohydrates")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text("Carbs")
                Text("\(carbs) g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            
            Spacer()
            
            VStack {
                Image("food")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text("Fats")
                Text("\(fats) g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            Spacer()
            
            VStack {
                Image("protein")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                Text("Protein")
                Text("\(proteins) g")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.1))
            )
            Spacer()
        }
    }
}

//#Preview {
//    MacroHeaderView(carbs: .constant(180), fats: .constant(56), proteins: .constant(28))
//}
