//
//  BibleView.swift
//  Bread
//
//  Created by Mingyao Li on 10/4/23.
//

import SwiftUI
import Combine

struct BibleView: View {
    @State private var searchText = ""
    @State private var searchResults: [Verse] = []
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack {
            Image(systemName: "book")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Read the Bible")
        }
    }
}



struct BibleView_Previews: PreviewProvider {
    static var previews: some View {
        BibleView()
    }
}

