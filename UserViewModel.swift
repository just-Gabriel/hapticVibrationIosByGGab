import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var telephones: [Telephone] = []
    @Published var experiences: [Experience] = []
    @Published var vibrations: [Vibration] = []
    @Published var text: String = ""

    var cancellables = Set<AnyCancellable>()
    private var experienceQueue: [Experience] = []
    private var isSubmittingExperience = false

    func createUser(user: User) {
        APIService.shared.createUser(user: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Erreur lors de la création de l'utilisateur : \(error)")
                    self.text = "Erreur lors de la création de l'utilisateur"
                }
            }, receiveValue: { user in
                self.users.append(user)
                self.text = "Utilisateur créé avec succès !"
            })
            .store(in: &cancellables)
    }

    func createTelephone(telephone: Telephone) {
        APIService.shared.createTelephone(telephone: telephone)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Erreur lors de la création du téléphone : \(error)")
                    self.text = "Erreur lors de la création du téléphone"
                }
            }, receiveValue: { telephone in
                self.telephones.append(telephone)
                self.text = "Téléphone créé avec succès !"
            })
            .store(in: &cancellables)
    }

    func createExperience(experience: Experience) {
        experienceQueue.append(experience)
        submitNextExperience()
    }

    private func submitExperience(_ experience: Experience) {
        isSubmittingExperience = true
        APIService.shared.createExperience(experience: experience)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isSubmittingExperience = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Erreur lors de la création de l'expérience : \(error)")
                    self.text = "Erreur lors de la création de l'expérience"
                }
                self.submitNextExperience()
            }, receiveValue: { [weak self] experience in
                self?.experiences.append(experience)
                self?.text = "Expérience créée avec succès !"
            })
            .store(in: &cancellables)
    }

    private func submitNextExperience() {
        guard !isSubmittingExperience, !experienceQueue.isEmpty else {
            return
        }
        let nextExperience = experienceQueue.removeFirst()
        submitExperience(nextExperience)
    }

    func createVibration(vibration: Vibration, completion: @escaping (Vibration) -> Void) {
        APIService.shared.createVibration(vibration: vibration)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Erreur lors de la création de la vibration : \(error)")
                    self.text = "Erreur lors de la création de la vibration"
                }
            }, receiveValue: { vibration in
                self.vibrations.append(vibration)
                self.text = "Vibration créée avec succès !"
                completion(vibration) // Renvoie la vibration créée avec l'ID
            })
            .store(in: &cancellables)
    }

    func fetchUsers() -> AnyPublisher<Void, Never> {
        APIService.shared.fetchUsers()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] users in
                self?.users = users
            })
            .map { _ in }
            .catch { _ in Just(()) }
            .eraseToAnyPublisher()
    }

    func fetchTelephones() -> AnyPublisher<Void, Never> {
        APIService.shared.fetchTelephones()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] telephones in
                self?.telephones = telephones
            })
            .map { _ in }
            .catch { _ in Just(()) }
            .eraseToAnyPublisher()
    }

    func fetchVibrations() -> AnyPublisher<Void, Never> {
        APIService.shared.fetchVibrations()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] vibrations in
                self?.vibrations = vibrations
            })
            .map { _ in }
            .catch { _ in Just(()) }
            .eraseToAnyPublisher()
    }
    
    func fetchExperiences() -> AnyPublisher<Void, Never> {
        APIService.shared.fetchExperiences()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] experiences in
                self?.experiences = experiences
            })
            .map { _ in }
            .catch { _ in Just(()) }
            .eraseToAnyPublisher()
    }
}
