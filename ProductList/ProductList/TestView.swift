import SwiftUI

struct TestView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some View {
        Text("Hello")
            .background(Color.yellow)
            .padding()
        Text("Hello")
            .padding()
            .background(Color.yellow)
    }
}

#Preview {
    TestView()
}
