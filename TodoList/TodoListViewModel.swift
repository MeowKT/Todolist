import SwiftUI
import Combine

class TodoListViewModel: ObservableObject {
    
    let todoStorage = TodoStorage()
    @Published var currentText = ""
    var pushToParent: AnyCancellable?
       
    init() {
        pushToParent = todoStorage.tasks
            .subscribe(on: RunLoop.main)
            .sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    public func addNote(text: String) {
        guard !text.isEmpty && todoStorage.tasks.value.first(where: { $0.text == text }) == nil else {
            return
        }
        todoStorage.tasks.value.append(Note(text: text))
        self.currentText = ""
    }
    
}

struct Note: Identifiable, Codable {
    let text: String
    var id: String = UUID().description
    var isOn: Bool = true
}


