//
//  BusView.swift
//  StudyConcurrencyJourney
//
//  Created by Shuraw on 3/26/24.
//

import SwiftUI


class BusManager {
    let isActive: Bool = false
    
    func changeDisplay() -> (title: String?, error: Error?) {
        if isActive {
            return ("버스가 출발합니다.", nil)
        }else {
            return (nil, URLError(.unknown))
        }
    }
    
    func changeDisplay2() -> Result<String, Error> {
        if isActive {
            return .success("버스가 출발합니다.")
        }else {
            return .failure(URLError(.unknown))
        }
    }
    
    func changeDisplay3() throws -> String {
        if isActive {
            return "버스가 출발합니다."
        }else {
            throw URLError(.unknown)
        }
    }
    
    func changeDisplay4() throws -> String {
        if isActive {
            return "버스가 출발합니다."
        }else {
            throw URLError(.unknown)
        }
    }
    
    func changeDisplayWithError() throws -> String {
        if isActive {
            return "버스가 출발합니다."
        }else {
            throw DisplayError.notDriveTime
        }
    }
}

class BusViewModel: ObservableObject {
    @Published var display: String = "버스가 출발하기 전"
    
    let manager = BusManager()
    
    func driving() {
        
        do {
            // 이때는 catch block으로 넘어가지않음
            if let newDisplay = try? manager.changeDisplay3() {
                self.display = newDisplay
            }
            
            let newDisplay2 = try manager.changeDisplay3()
            self.display = newDisplay2
        }catch {
            self.display = error.localizedDescription
        }
        
        
//        let something = manager.changeDisplay2()
//        switch something {
//        case .success(let success):
//            self.display = success
//        case .failure(let failure):
//            self.display = failure.localizedDescription
//        }
        
//        let returnedValue = manager.changeDisplay()
//        if let newDisplay = returnedValue.title {
//            self.display = newDisplay
//        }else if let error = returnedValue.error {
//            self.display = error.localizedDescription
//        }
    }
    
    func drivingReally() throws {
        self.display = try manager.changeDisplayWithError()
    }
}

struct BusView: View {
    @StateObject private var busVM = BusViewModel()
    @State private var errorWrapper: ErrorWrapper?
    
    var body: some View {
        Text(busVM.display)
            .font(.largeTitle)
            .bold()
            .onTapGesture {
                busVM.driving()
                do {
                    try busVM.drivingReally()
                }catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "버스가 운행시간이 아닙니다.")
                }
            }
            .sheet(item: $errorWrapper) { wrapper in
                ErrorView(errorWrapper: wrapper)
            }
    }
}

#Preview {
    BusView()
}
