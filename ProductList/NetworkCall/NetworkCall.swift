import Combine
import Foundation
import SwiftUI

// Service Protocol
protocol ProductServiceProtocol {
    func fetchProducts() -> AnyPublisher<[Product], Error>
    func fetchProducts() async throws -> [Product]
}

// Service Implementation
class ProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        let url = URL(string: "https://fakestoreapi.com/products")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Product].self, from: data)
        
    }
    
    func fetchProducts() -> AnyPublisher<[Product], Error> {
        let url = URL(string: "https://fakestoreapi.com/products")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Product].self, decoder: JSONDecoder())
           // .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
