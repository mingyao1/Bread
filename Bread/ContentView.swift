import SwiftUI
import Combine

struct ContentView: View {
    @State private var searchText = ""
    @State private var searchResults: [Verse] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Bread: The best Bible app")
            
            TextField("Search for a verse...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Search") {
                performSearch(query: searchText)
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
        .padding()
    }
    func performSearch(query: String) {
        guard let url = URL(string: "http://192.168.1.104:3000/search?query=\(query)") else { return }
        
        // No need for an API key here if it's already on the server
        let request = URLRequest(url: url)
        
        cancellable = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ApiResponse.self, decoder: JSONDecoder())  // Replace with your model
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // Handle error here
            }, receiveValue: { value in
                self.searchResults = value.data.verses
                print(value.data.verses.count)
            })
    }
}

struct ApiResponse: Decodable {
    let data: SearchData
    let meta: MetaData
}

struct SearchData: Decodable {
    let query: String
    let limit: Int
    let offset: Int
    let total: Int
    let verseCount: Int
    let verses: [Verse]
}

struct Verse: Decodable, Identifiable {
    let id: String
    let orgId: String
    let bookId: String
    let bibleId: String
    let chapterId: String
    let reference: String
    let text: String
}

struct MetaData: Decodable {
    let fums: String
    let fumsId: String
    let fumsJsInclude: String
    let fumsJs: String
    let fumsNoScript: String
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
