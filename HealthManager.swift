//
//  HealthManager.swift
//  NutriMind
//
//  Created by Preeten Dali on 11/01/24.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    static var startOfWeek: Date {
        let calander = Calendar.current
        var componant = calander.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        componant.weekday = 2
        return calander.date(from: componant)!
    }
    
    static var oneMonthAgo: Date {
        let calander = Calendar.current
        let oneMonth = calander.date(byAdding: .month, value: -1, to: Date())
        return calander.startOfDay(for: oneMonth!)
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

class HealthManager: ObservableObject{
    
    let healthStore = HKHealthStore()
    
    @Published var activites: [String: Activity] = [:]
    @Published var oneMonthChartData = [DailyStepView]()
    @Published var mockActivities: [String: Activity] = [
        "todaySteps" : Activity(id: 0, title: "Today Step", subTitle: "Goal: 10,000", image: "figure.walk", amount: "1,241"),
        "todayCalories" : Activity(id: 1, title: "Today Calories", subTitle: "Goal: 130", image: "flame", amount: "1241")
    ]
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let workout = HKObjectType.workoutType()
        
        let healthTypes: Set = [steps, calories, workout]
        
        Task{
            do{
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fatchTodaySteps()
                fatchTodayCalories()
                fatchWeekRunningStats()
                fatchCurrentWeekStrengthSatts()
                fetchPastMonthStepData()
            } catch {
                print("error fatching health data")
            }
        }
    }
    
    func fetchDailySteps(startDate: Date, completion: @escaping([DailyStepView]) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        query.initialResultsHandler = { query, result, error in
            guard let result = result else {
                completion([])
                return
            }
            var dailySteps = [DailyStepView]()
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepView(date: statistics.startDate, stepCount: statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0.00))
            }
            completion(dailySteps)
        }
        
        healthStore.execute(query)
    }
    
    func fatchTodaySteps() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fatching todays step data")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = Activity(id: 0, title: "Today Step", subTitle: "Goal: 10,000", image: "figure.walk", amount: stepCount.formattedString())
            
            DispatchQueue.main.async {
                self.activites["TodaySteps"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fatchTodayCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("error fatching todays calorie data")
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            let activity = Activity(id: 1, title: "Today Calories", subTitle: "Goal: 130", image: "flame", amount: caloriesBurned.formattedString())
            
            DispatchQueue.main.async {
                self.activites["TodayCalories"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fatchWeekRunningStats() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        let pradicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: pradicate, limit: 20, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout] , error == nil else {
                print("error fatching week running data")
                return
            }
            
            var count: Int = 0
            for workout in workouts{
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 2, title: "Running", subTitle: "Goal: 60 min", image: "figure.run", amount: "\(count) minutes")
            
            DispatchQueue.main.async {
                self.activites["weekRunning"] = activity
            }
        }
        healthStore.execute(query)
    }
    
    func fatchCurrentWeekStrengthSatts() {
        let workout = HKSampleType.workoutType()
        let timePredicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .traditionalStrengthTraining)
        let pradicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        let query = HKSampleQuery(sampleType: workout, predicate: pradicate, limit: 20, sortDescriptors: nil) { _, sample, error in
            guard let workouts = sample as? [HKWorkout] , error == nil else {
                print("error fatching week running data")
                return
            }
            
            var count: Int = 0
            for workout in workouts{
                let duration = Int(workout.duration)/60
                count += duration
            }
            let activity = Activity(id: 3, title: "Weight Lifting", subTitle: "This Week", image: "dumbbell", amount: "\(count) minutes")
            
            DispatchQueue.main.async {
                self.activites["weekStrength"] = activity
            }
        }
        healthStore.execute(query)
    }
}

//MARK: Chart Data

extension HealthManager {
    
    func fetchPastMonthStepData() {
        fetchDailySteps(startDate: .oneMonthAgo) { dailySteps in
            DispatchQueue.main.async {
                self.oneMonthChartData = dailySteps
            }
        }
    }
}
