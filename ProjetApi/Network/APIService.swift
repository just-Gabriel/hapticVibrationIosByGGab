import Foundation
import Combine

class APIService {
    static let shared = APIService()
    let baseURL = "http://10.0.3.174:8000/api/"

    private init() {}

    func createUser(user: User) -> AnyPublisher<User, Error> {
        let url = URL(string: baseURL + "users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let body = try? encoder.encode(user)
        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createTelephone(telephone: Telephone) -> AnyPublisher<Telephone, Error> {
        let url = URL(string: baseURL + "telephones")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let body = try? encoder.encode(telephone)
        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Telephone.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createExperience(experience: Experience) -> AnyPublisher<Experience, Error> {
        let url = URL(string: baseURL + "experiences")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let body = try? encoder.encode(experience)
        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Experience.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createVibration(vibration: Vibration) -> AnyPublisher<Vibration, Error> {
        let url = URL(string: baseURL + "vibrations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        let body = try? encoder.encode(vibration)
        request.httpBody = body

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Vibration.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchUsers() -> AnyPublisher<[User], Error> {
        let url = URL(string: baseURL + "users")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchTelephones() -> AnyPublisher<[Telephone], Error> {
        let url = URL(string: baseURL + "telephones")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Telephone].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchVibrations() -> AnyPublisher<[Vibration], Error> {
        let url = URL(string: baseURL + "vibrations")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Vibration].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
