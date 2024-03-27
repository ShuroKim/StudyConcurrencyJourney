//
//  BusView.swift
//  StudyConcurrencyJourney
//
//  Created by Shuraw on 3/26/24.
//

import SwiftUI

class BusViewModel: ObservableObject {
    @Published var display: String = "버스가 출발하기 전"
}

struct BusView: View {
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    BusView()
}
