//
// AddMacroView.swift
// NutriMind
//
// Created by Preeten Dali on 28/01/24.
//

import SwiftUI

struct AddMacroView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.dismiss) var dismiss

  @State private var food = ""
  @State private var date = Date()
  @State private var showAlert = false
  @State private var isLoading = false

  var body: some View {
    ZStack(alignment: .topTrailing) {
      if isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        VStack(spacing: 20) {
          Text("Add Macro")
            .font(.largeTitle)

          TextField("what did you eat?", text: $food)
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 15)
                .stroke()
            )
          DatePicker("Date", selection: $date)

          Button {
            if food.count > 2 {
              isLoading = true
              sendItemToChatGPT()
            }
          } label: {
            Text("Done")
              .bold()
              .padding()
              .frame(maxWidth: .infinity)
              .foregroundStyle(Color(uiColor: .systemBackground))
              .background(
                RoundedRectangle(cornerRadius: 15)
                  .fill(Color(uiColor: .label))
              )
          }
        }
        .padding(.top, 24)
        .padding(.horizontal)
        .alert("Oops", isPresented: $showAlert) {
          Text("ok")
        } message: {
          Text("Please make sure you enter a valid food item and try again.")
        }
      }

      Button("", systemImage: "x.circle.fill") {
        dismiss()
      }
      .font(.title2)
      .foregroundStyle(.primary)
    }
  }

  private func sendItemToChatGPT() {
    Task {
      do {
        let result = try await
          OpenAIService.shared
            .sendPromptToChatGPT(message: food)
        saveMacro(result)
        dismiss()
      } catch {
        if let openAIError = error as? OpenAIError {
          switch openAIError {
          case .noFunctionCall:
            showAlert = true
          case .unableToConvertStringIntoData:
            print(error.localizedDescription)
          }
        } else {
          print(error.localizedDescription)
        }
        isLoading = false
      }
        do { isLoading = false } 
    }
  }

  private func saveMacro(_ result: MecroResult) {
    let macro = Macro(food: result.food, createAt: .now, date: .now, carbs: result.carbs, fats: result.fats, protein: result.protein)
    modelContext.insert(macro)
  }
}

#Preview {
  AddMacroView()
}
