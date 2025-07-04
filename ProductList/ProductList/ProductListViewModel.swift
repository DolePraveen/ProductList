import Combine
import SwiftUI
import Foundation
// ViewModel
class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var errorMessage: String? = nil
    @Published var cartItems: Set<Int> = []
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @State var data: Data?
    
    private var cancellables = Set<AnyCancellable>()
    private let service: ProductServiceProtocol
    init(service: ProductServiceProtocol) {
        self.service = service
        fetchAsynProduct()
    }

    
    func fetchAsynProduct() {
       
        Task {
            do {
                let fetchProduct = try await self.service.fetchProducts()
                DispatchQueue.main.async { [weak self] in
                    self?.products = fetchProduct
                }
            } catch let error {
                
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchProducts() {
        service.fetchProducts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }

    func toggleCart(for productId: Int) {
        if cartItems.contains(productId) {
            cartItems.remove(productId)
        } else {
            cartItems.insert(productId)
        }
    }
}
