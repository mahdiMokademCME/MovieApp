import Foundation

extension Optional where Wrapped == TimeInterval {
    func orDefault() -> TimeInterval {
        return self ?? -99
    }
}
