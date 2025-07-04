import SwiftUI

struct ProductNavigationStackView: Identifiable, Hashable {
    let id = UUID()
    let name: String
}

struct NavigationStackView: View {
    let products = [ProductNavigationStackView(name: "iPhone"), ProductNavigationStackView(name: "MacBook")]

    var body: some View {
        NavigationStack {
            List(products) { product in
               // Text(product.name)
                NavigationLink(product.name, value: product)
            }
            .navigationTitle("Products")
            .navigationDestination(for: ProductNavigationStackView.self) { product in
                //Text("Details for \(product.name)")
                DetailView(detailViewModelTitle: DetailViewModelTitle(title: product))
            }
        }
    }
}

class DetailViewModelTitle: ObservableObject {
    @Published var title: ProductNavigationStackView
    
    init(title: ProductNavigationStackView) {
        self.title = title
    }
}

struct DetailView: View {
    
    @StateObject var detailViewModelTitle: DetailViewModelTitle
    
    init(detailViewModelTitle: DetailViewModelTitle) {
        
        _detailViewModelTitle = StateObject(wrappedValue: detailViewModelTitle)
    }
   // var detailTitle: String
    var body: some View {
        VStack {
            Text(detailViewModelTitle.title.name)
                .font(.headline)
        }
    }
}
