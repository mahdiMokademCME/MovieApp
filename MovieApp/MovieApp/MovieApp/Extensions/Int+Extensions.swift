import Foundation

extension Optional where Wrapped == Int {
    func orDefault() -> Int {
        return self ?? -99
    }
}
