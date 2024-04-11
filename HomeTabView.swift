import SwiftUI

struct HomeTabView: View {
    
    @EnvironmentObject var manager: HealthManager
    @Binding var showSignInView: Bool
    @State var selectedTab = "Home"

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(manager)
                .tag("Home")
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ChartsView()
                .environmentObject(manager)
                .tag("Charts")
                .tabItem {
                    Label("Charts", systemImage: "chart.bar.xaxis")
                }
            BMIView()
                .tag("BMI")
                .tabItem {
                    Label("BMI", systemImage: "ruler")
                }
            MacroView()
                .tag("Macro")
                .tabItem {
                    Label("Macro", systemImage: "chart.pie")
                }
            SettingsView(showSignInView: .constant(false))
                .tag("Setting")
                .tabItem {
                    Label("Settings", systemImage: "person")
                }
        }
    }
}

struct TabView_Preview: PreviewProvider {
    static var previews: some View {
        HomeTabView(showSignInView: .constant(false))
            .environmentObject(HealthManager())
    }
}
