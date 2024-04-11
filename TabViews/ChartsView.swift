//
//  ChartsView.swift
//  NutriMind
//
//  Created by Preeten Dali on 12/01/24.
//

import SwiftUI
import Charts

struct DailyStepView: Identifiable {
    let id = UUID()
    let date: Date
    let stepCount: Double
    
}

enum chartOptions {
    case oneWeek
    case oneMonth
    case threeMonth
    case yearToDate
    case oneYear
}

struct ChartsView: View {
    @EnvironmentObject var  manager: HealthManager
    @State var selectedChart: chartOptions = .oneMonth
    var body: some View {
        VStack (spacing: 12) {
            Text("Health Data")
                .font(.largeTitle)
                .padding(.horizontal)
                .foregroundColor(.secondary)
                .frame(alignment: .top)
            Chart {
                ForEach(manager.oneMonthChartData) { daily in
                    BarMark(x: .value(daily.date.formatted(), daily.date, unit: .day), y: .value("Steps", daily.stepCount))
                }
            }
            .foregroundColor(.blue)
            .frame(height: 350)
            .padding(.horizontal)
            
            HStack {
                Button("1W") {
                    withAnimation {
                        selectedChart = .oneWeek
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneWeek ? .white : .blue)
                .background(selectedChart == .oneWeek ? .blue : .clear)
                .cornerRadius(10)
                
                Button("1M") {
                    withAnimation {
                        selectedChart = .oneMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneMonth ? .white : .blue)
                .background(selectedChart == .oneMonth ? .blue : .clear)
                .cornerRadius(10)
                
                Button("3M") {
                    withAnimation {
                        selectedChart = .threeMonth
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .threeMonth ? .white : .blue)
                .background(selectedChart == .threeMonth ? .blue : .clear)
                .cornerRadius(10)
                
                Button("YTD") {
                    withAnimation {
                        selectedChart = .yearToDate
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .yearToDate ? .white : .blue)
                .background(selectedChart == .yearToDate ? .blue : .clear)
                .cornerRadius(10)
                
                Button("1Y") {
                    withAnimation {
                        selectedChart = .oneYear
                    }
                }
                .padding(.all)
                .foregroundColor(selectedChart == .oneYear ? .white : .blue)
                .background(selectedChart == .oneYear ? .blue : .clear)
                .cornerRadius(10)
            }
            
        }
        .onAppear {
            print(manager.oneMonthChartData)
        }
    }
}

#Preview {
    ChartsView()
        .environmentObject(HealthManager())
}
