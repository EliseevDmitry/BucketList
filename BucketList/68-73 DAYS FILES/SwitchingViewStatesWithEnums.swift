//
//  SwitchingViewStatesWithEnums.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 21.07.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
} 
struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}
struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}

struct SwitchingViewStatesWithEnums: View {
    //MARK: - PROPERTIES
    enum LoadingState {
        case loading, success, failed
    }
    //свойство для отслеживания состояния внутри структуры
    @State private var loadingState = LoadingState.success
    //MARK: - BODY
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

//MARK: - PREVIEW
#Preview {
    SwitchingViewStatesWithEnums()
}
