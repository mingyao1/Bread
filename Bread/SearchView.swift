import SwiftUI
import Combine

struct SearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [Verse] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Bread: The best Bible app")
            
            TextField("Search for a verse...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit{
                    performSearch(raw_query: searchText)
                }
                .submitLabel(.go)
                .padding()
            
            Button("Search") {
                performSearch(raw_query: searchText)
            }
            .padding()
            
            
            List(searchResults) { verse in
                VStack(alignment: .leading) {
                    Text(verse.reference)
                        .font(.headline)
                    Text(verse.text)
                        .font(.subheadline)
                        .padding(.top, 8)
                }
                .padding(.vertical, 12)
            }
        }
        .dismissKeyboardOnTap()
    }
    func performSearch(raw_query: String) {
        let query = raw_query.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.count == 0 {
            return
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        guard let url = URL(string: API_ENDPOINT+"/search") else { return }
        print("Sending query", query)
        // No need for an API key here if it's already on the server
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "query": query
        ])
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ApiResponse.self, decoder: JSONDecoder())  // Replace with your model
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print("error:", completion)
                print("status code:" /*insert code here*/)
            }, receiveValue: { value in
                self.searchResults = value.data.verses
                print(value.data.verses.count, "results")
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
