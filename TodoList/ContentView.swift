import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel = TodoListViewModel()

    var body: some View {
        VStack {
            HStack {
                TextField("Type here", text: $viewModel.currentText)
                .padding(15)
                Button(action: {
                    viewModel.addNote(text: viewModel.currentText)
                }) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                }
                .padding(.trailing, 30)
            }
            List(Array(viewModel.todoStorage.tasks.value.enumerated()), id: \.1.id) { ind, task in
                HStack {
                    Text(task.text)
                        .strikethrough(!task.isOn)
                        .foregroundColor(task.isOn ? .black : .gray)
                        .onTapGesture {
                            viewModel.todoStorage.tasks.value[ind].isOn.toggle()
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodoListView()
        }
    }
}
