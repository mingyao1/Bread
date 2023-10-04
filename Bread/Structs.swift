//
//  Structs.swift
//  Bread
//
//  Created by Mingyao Li on 10/4/23.
//

import SwiftUI


let API_ENDPOINT = "http://10.8.135.181:3000" // "http://localhost:3000"

struct DismissKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboard())
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
