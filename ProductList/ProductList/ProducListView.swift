import SwiftUI

// Views
struct ProductListView: View {
    @StateObject var viewModel: ProductListViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.products) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product, isInCart: viewModel.cartItems.contains(product.id)) {
                                    viewModel.toggleCart(for: product.id)
                                }
                            }
                        }
                    }.padding()
                }
            }
            .navigationTitle("Catalog")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView(cartItems: viewModel.cartItems, products: viewModel.products)) {
                        HStack {
                            Image(systemName: "cart")
                            if !viewModel.cartItems.isEmpty {
                                Text("\(viewModel.cartItems.count)").font(.caption2).foregroundColor(.white).padding(4).background(Circle().fill(Color.red))
                            }
                        }
                    }
                }
            }
        }
    }
}
