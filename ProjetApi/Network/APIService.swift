import Foundation
import Combine

class APIService {
    static let shared = APIService()
    let baseURL = "http://64.226.103.95:8000/api/"
    
    private init() {}

    private var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 960
        configuration.timeoutIntervalForResource = 960
        return URLSession(configuration: configuration)
    }()

    func createUser(user: User) -> AnyPublisher<User, Error> {
        let url = URL(string: baseURL + "users")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let body = try encoder.encode(user)
            request.httpBody = body
            print("Requête Utilisateur : \(String( data: body, encoding: .utf8)!)")
        } catch {
            print("Erreur lors de l'encodage de l'utilisateur : \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Utilisateur : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createTelephone(telephone: Telephone) -> AnyPublisher<Telephone, Error> {
        let url = URL(string: baseURL + "telephones")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let body = try encoder.encode(telephone)
            request.httpBody = body
            print("Requête Telephone : \(String(data: body, encoding: .utf8)!)")
        } catch {
            print("Erreur lors de l'encodage du téléphone : \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Telephone : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: Telephone.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func createExperience(experience: Experience) -> AnyPublisher<Experience, Error> {
        
            let url = URL(string: baseURL + "experiences")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let body = try encoder.encode(experience)
            request.httpBody = body
            print("Requête Experience : \(String(data: body, encoding: .utf8)!)")
        } catch {
            print("Erreur lors de l'encodage de l'expérience : \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Experience : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: Experience.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    /*func createVibration(vibration: Vibration) -> AnyPublisher<Vibration, Error> {
        let url = URL(string: baseURL + "vibrations")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let encoder = JSONEncoder()
        do {
            let body = try encoder.encode(vibration)
            request.httpBody = body
            print("Requête Vibration : \(String(data: body, encoding: .utf8)!)")
        } catch {
            print("Erreur lors de l'encodage de la vibration : \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Vibration : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: Vibration.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }*/

    func fetchUsers() -> AnyPublisher<[User], Error> {
        let url = URL(string: baseURL + "users")!
        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Utilisateurs : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: [User].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchTelephones() -> AnyPublisher<[Telephone], Error> {
        let url = URL(string: baseURL + "telephones")!
        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Telephones : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: [Telephone].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchVibrations() -> AnyPublisher<[Vibration], Error> {
        let url = URL(string: baseURL + "vibrations")!
        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Vibrations : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: [Vibration].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchExperiences() -> AnyPublisher<[Experience], Error> {
        let url = URL(string: baseURL + "experiences")!
        return session.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                if let response = result.response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                    let bodyString = String(data: result.data, encoding: .utf8) ?? "No response body"
                    print("Erreur serveur (code \(response.statusCode)) : \(bodyString)")
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .handleEvents(receiveOutput: { data in
                print("Réponse Experiences : \(String(data: data, encoding: .utf8)!)")
            })
            .decode(type: [Experience].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
