import UIKit
import Combine

class ViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData() {
        APIService.shared.fetchUsers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching users: \(error)")
                }
            }, receiveValue: { users in
                print("Users: \(users)")
            })
            .store(in: &cancellables)
    }
}
