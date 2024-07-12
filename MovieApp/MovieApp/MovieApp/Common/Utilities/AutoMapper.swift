import Foundation
import Swinject

struct AutoMapper<From, To> {
    let fromType = From.self
    let toType = To.self
    private let block: (From) -> To
    init(using: @escaping (From) -> To) {
        self.block = using
    }

    func map(from: From) -> To {
        return block(from)
    }
}
