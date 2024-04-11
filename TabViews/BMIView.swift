//
// BMIView.swift
// NutriMind
//
// Created by Preeten Dali on 29/03/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

enum Gender: String {
    case male = "Male"
    case female = "Female"
}

struct BMIView: View {
    
    @State private var height: Double?
    @State private var weight: Double?
    @State private var age: Int?
    @State private var bmi: Double = 0.0
    @State private var bmiScale: String = ""
    @State private var errorMessage: String? = nil
    @State private var showingAlert = false
    @State private var selectedGender: Gender = .male
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Height (in meters)", value: $height, format: .number)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                TextField("Weight (in kilograms)", value: $weight, format: .number)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                TextField("Age", value: $age, format: .number)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                
                Picker("Gender", selection: $selectedGender) {
                    Text(Gender.male.rawValue).tag(Gender.male)
                    Text(Gender.female.rawValue).tag(Gender.female)
                }
                .padding()
                .pickerStyle(.segmented)
                
                Button("Calculate BMI") {
                    self.calculateBMI()
                    saveBMIDataToFirebase()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                if bmi > 0.0 {
                    Text("Your BMI is: \(String(format: "%.2f", bmi))")
                    Text("BMI Scale: \(bmiScale)")
                }
            }
            .padding()
            .navigationTitle("BMI Calculator")
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "An error occurred."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func calculateBMI() {
        guard let height = height, let weight = weight, let age = age else {
            errorMessage = "Please enter all data."
            showingAlert = true
            return
        }
        if height <= 0.0 {
            errorMessage = "Please enter a valid height."
            showingAlert = true
            return
        }
        if weight <= 0.0 {
            errorMessage = "Please enter a valid weight."
            showingAlert = true
            return
        }
        
        bmi = weight / (height * height)
        let bmiScale = determineBMIScale(bmi: bmi)
        self.bmiScale = bmiScale
    }
    
    private func determineBMIScale(bmi: Double) -> String {
        switch bmi {
        case 0..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal weight"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
    
    private func saveBMIDataToFirebase() {
        guard let userId = Auth.auth().currentUser?.uid, let height = height, let weight = weight, let age = age else { return }
        
        let bmiData: [String: Any] = [
            "height": height,
            "weight": weight,
            "age": Double(age),
            "bmi": bmi,
            "bmiScale": bmiScale,
            "gender": selectedGender.rawValue,
            "timestamp": Date().description
        ]
        
        print("Saving BMI data to Firebase for user: \(userId)")
        
        db.collection("users").document(userId).collection("bmiData").addDocument(data: bmiData) { error in
            if let error = error {
                print("Error saving BMI data to Firebase: \(error.localizedDescription)")
            } else {
                print("BMI data saved successfully to Firebase")
            }
        }
    }
}

struct BMIView_Previews: PreviewProvider {
    static var previews: some View {
        BMIView()
    }
}
