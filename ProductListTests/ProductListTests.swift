//import Testing
//@testable import ProductList
//
//struct ProductListTests {
//
//    @Test func example() async throws {
//        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
//    }
//
//}

// Unit Test Example
import XCTest
import Combine
@testable import ProductList

class MockProductService: ProductServiceProtocol {
    
    var shouldReturnError = false

    func fetchProducts() async throws -> [Product] {
        if shouldReturnError {
            return []
        } else {
            let mockProduct = Product(id: 1, title: "Test", description: "Test desc", price: 99.99, image: "", rating: Rating(rate: 4.5, count: 100))
            return [mockProduct]
        }
    }
    
    func fetchProducts() -> AnyPublisher<[Product], Error> {
        if shouldReturnError {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        } else {
            let mockProduct = Product(id: 1, title: "Test", description: "Test desc", price: 99.99, image: "", rating: Rating(rate: 4.5, count: 100))
            return Just([mockProduct])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func testFetchProductsSuccess() {
        let service = MockProductService()
        viewModel = ProductListViewModel(service: service)

        let expectation = XCTestExpectation(description: "Fetch products")

        viewModel.$products.dropFirst().sink { products in
            XCTAssertEqual(products.count, 1)
            expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }

    func testFetchProductsFailure() {
        let service = MockProductService()
        service.shouldReturnError = true
        viewModel = ProductListViewModel(service: service)

        let expectation = XCTestExpectation(description: "Handle error")

        viewModel.$errorMessage.dropFirst().sink { message in
            XCTAssertNil(message)
            expectation.fulfill()
        }.store(in: &cancellables)

        wait(for: [expectation], timeout: 5)
    }
}
