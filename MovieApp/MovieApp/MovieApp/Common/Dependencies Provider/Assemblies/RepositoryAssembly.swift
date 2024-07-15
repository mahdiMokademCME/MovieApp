import Foundation
import Swinject

class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        
        container.register(MoviesRepository.self) { resolver in
            //here we can decide to return the Real or Mock implementation of the Repository
            return MoviesRepositoryRealImplementation.init()
        }
    }
}
