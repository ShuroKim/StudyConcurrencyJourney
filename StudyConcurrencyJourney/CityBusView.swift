//
//  CityBusView.swift
//  StudyConcurrencyJourney
//
//  Created by Shuraw on 3/27/24.
//

import SwiftUI

class CityBusManager {
    let ticket = URL(string: "https://img.icons8.com/?size=512&id=WBn88SGX4mke&format=png")!
    
    func downloadWithEscaping(completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: ticket) { data, response, error in
            if let error = error {
                completion(nil, error)
            }else if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(nil, URLError(.badServerResponse))
            }else {
                guard let data = data else {return}
                
                let image = UIImage(data: data)
                completion(image, nil)
            }
        }
        .resume()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        
        // await 기다린다, 비동기 진행 중 결과값을 대기함
        let (data, response) = try await URLSession.shared.data(from: ticket)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return UIImage(data: data)
    }
}

class CityBusViewModel: ObservableObject {
    @Published var passenger: UIImage?
    
    private let busMgr = CityBusManager()
    
//    func fetchPessengerImage() async {
////        busMgr.downloadWithEscaping { [weak self] image, error in
////            DispatchQueue.main.async {
////                self?.passenger = image
////            }
////        }
//
//        let newPassenger = try? await busMgr.downloadWithAsync()
//        
//        await MainActor.run {
//            self.passenger = newPassenger
//        }
//    }
    
    @MainActor  // class에 선언해줄수도있음
    func fetchPessengerImage() async {
//        busMgr.downloadWithEscaping { [weak self] image, error in
//            DispatchQueue.main.async {
//                self?.passenger = image
//            }
//        }

        let newPassenger = try? await busMgr.downloadWithAsync()
        self.passenger = newPassenger
    }
}

// async await와 combine은 다르게 사용됨, 같이도 사용됨 비슷하면서 다르게
// 

struct CityBusView: View {
    @StateObject private var vm = CityBusViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let passenger = vm.passenger {
                 Image(uiImage: passenger)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .cornerRadius(10)
            }
            
            Button("승객 태우기") {
                Task {
                    await vm.fetchPessengerImage()
                }
            }
            .font(.largeTitle)
            .padding()
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(10)
        }
//        .onAppear(perform: {
//            Task {
//                await vm.fetchPessengerImage()
//            }
//        })
    }
}

#Preview {
    CityBusView()
}
