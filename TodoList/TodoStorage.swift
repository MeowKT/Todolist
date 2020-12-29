import SwiftUI
import Combine

class TodoStorage {
    let tasks: CurrentValueSubject<[Note], Never> = CurrentValueSubject([])
    private var autoSave: Cancellable?
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("note.data")
    }
    
    init() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                return
            }
            guard let tasks = try? JSONDecoder().decode([Note].self, from: data) else {
                fatalError("Can't decode saved note data.")
            }
            self?.tasks.value = tasks
            
            self?.autoSave = self?.tasks
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink(receiveValue: self!.save)
        }
    }
    
    private func save(task: [Note]) {
        guard let data = try? JSONEncoder().encode(tasks.value) else { fatalError("Error encoding data") }
        do {
            let outfile = Self.fileURL
            try data.write(to: outfile)
        } catch {
            fatalError("Can't write to file")
        }
    }
    
}
