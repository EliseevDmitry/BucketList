//
//  WritingDataToDocDir.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 21.07.2024.
//

import SwiftUI

struct WritingDataToDocDir: View {
    //MARK: - BODY
    var body: some View {
        Button("Read and Write") {
            let data = Data("Test Message".utf8)
            let url = URL.documentsDirectory.appending(path: "message.txt")
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let input = try String(contentsOf: url)
                print("\(input) - прочитано из файла")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - PREVIEW
#Preview {
    WritingDataToDocDir()
}
