//
//  SwinjectDI.swift
//  PhamPhuongNamNotes
//
//  Created by P. Nam on 18/01/2024.
//

import Foundation
import Swinject
import FirebaseFirestore

func register(container: Container) {
    container.register(KeychainManaging.self) { resolve in
        KeychainManager(service: Bundle.main.bundleIdentifier!)
    }.inObjectScope(.container)
    container.register(Firestore.self) { resolve in
        Firestore.firestore()
    }.inObjectScope(.container)
    
    container.register(NoteNetwork.self) { resolver in
        FirebaseNotes(db: resolver.resolve())
    }.inObjectScope(.container)
    container.register(UserLocal.self) { resolver in
        KeychainUser(keychainManager: resolver.resolve())
    }.inObjectScope(.container)
    
    container.register(UserRepository.self) { resolver in
        UserRepositoryImpl(local: resolver.resolve())
    }.inObjectScope(.container)
    container.register(NotesRepository.self) { resolver in
        NotesRepositoryImpl(network: resolver.resolve())
    }.inObjectScope(.container)
    
    container.register(MainUseCase.self) { resolver in
        MainUseCaseImpl(
            userRepository: resolver.resolve(),
            notesRepository: resolver.resolve()
        )
    }.inObjectScope(.container)
    container.register(MainViewModel.self) { resolver in
        MainViewModel(mainUseCase: container.resolve())
    }
    
    container.register(LoginUseCase.self) { resolver in
        LoginUseCaseImpl(userRepository: resolver.resolve())
    }.inObjectScope(.container)
    container.register(LoginViewModel.self) { resolver in
        LoginViewModel(usecase: resolver.resolve())
    }
    
    container.register(LoginedUseCase.self) { resolver in
        LoginedUseCaseImpl(userRepository: resolver.resolve())
    }.inObjectScope(.container)
    container.register(LoginedViewModel.self) { resolver in
        LoginedViewModel(usecase: resolver.resolve())
    }
    
    container.register(AddNoteUseCase.self) { resolver in
        AddNoteUseCaseImpl(
            userRepository: resolver.resolve(),
            notesRepository: resolver.resolve()
        )
    }.inObjectScope(.container)
    container.register(AddNoteViewModel.self) { resolver in
        AddNoteViewModel(usecase: resolver.resolve())
    }
}

extension Resolver {
    func resolve<T>() -> T {
        resolve(T.self)!
    }
}
