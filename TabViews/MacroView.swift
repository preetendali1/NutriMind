//
//  AIDietView.swift
//  NutriMind
//
//  Created by Preeten Dali on 11/01/24.
//

import SwiftUI
import SwiftData

struct MacroView: View {
    @State var carbs = 0
    @State var fats = 0
    @State var protens = 0
    
    @Query var macros: [Macro]
    @State var dailyMacros = [DailyMacro]()
    @State var showTextField = false
    @State var food = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("Today's Macros")
                        .font(.title)
                        .padding()
                    MacroHeaderView(carbs: carbs, fats: fats, proteins: protens)
                        .padding()
                    
                    
                    VStack (alignment: .leading) {
                        Text("Previous")
                            .font(.title)
                        
                        ForEach(dailyMacros) { macro in
                            MacroDayView(macro: macro)
                            
                        }
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem {
                    Button {
                        showTextField = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.blue, .blue)
                    }
                }
            }
            .sheet(isPresented: $showTextField) {
                AddMacroView()
                    .presentationDetents([.fraction(0.4)])
            }
            .onAppear {
                fatchDailyMacros()
                fatchTodaysMacros()
            }
            .onChange(of: macros) { _, _ in
                fatchDailyMacros()
                fatchTodaysMacros()
            }
        }
    }
    private func fatchDailyMacros() {
        let dates: Set<Date> = Set(macros.map({ Calendar.current.startOfDay(for: $0.date)}))
        
        var dailyMacros = [DailyMacro]()
        for date in dates {
            let filterMacros = macros.filter({ Calendar.current.startOfDay(for: $0.date) == date })
            let carbs: Int = filterMacros.reduce(0, { $0 + $1.carbs })
            let fats: Int = filterMacros.reduce(0, { $0 + $1.fats })
            let protein: Int = filterMacros.reduce(0, { $0 + $1.protein })
            
            let macro = DailyMacro(date: date, carbs: carbs, fats: fats, protein: protein)
            dailyMacros.append(macro)
        }
        
        self.dailyMacros = dailyMacros.sorted(by: { $0.date > $1.date })
    }
    
    private func fatchTodaysMacros() {
        if let firstDateMacro = dailyMacros.first, Calendar.current.startOfDay(for: firstDateMacro.date) == Calendar.current.startOfDay(for: .now) {
            carbs = firstDateMacro.carbs
            fats = firstDateMacro.fats
            protens = firstDateMacro.protein
        }
    }
}

#Preview {
    
    MacroView()
    
}
