//
//  ActivityCardView.swift
//  NutriMind
//
//  Created by Preeten Dali on 11/01/24.
//

import SwiftUI

struct Activity {
    let id: Int
    let title: String
    let subTitle: String
    let image: String
    let amount: String
}

struct ActivityCardView: View {
    
    @State var activity: Activity
    
    var body: some View {
        ZStack{
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5){
                        Text(activity.title)
                            .font(.system(size: 16))
                        
                        Text(activity.subTitle)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(.blue)
                }
                
                Text(activity.amount)
                    .font(.system(size: 24))
                    .minimumScaleFactor(0.6)
                    .bold()
                    .padding(.bottom)
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCardView(activity: Activity(id: 0, title: "Daily Steps", subTitle: "Goal: 10,000", image: "figure.walk", amount: "6,545"))
}
