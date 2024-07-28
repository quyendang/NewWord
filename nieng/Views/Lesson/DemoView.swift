//
//  DemoView.swift
//  nieng
//
//  Created by Quyen Dang on 14/11/2023.
//

import SwiftUI

struct Student {
    var name: String
    var age: Int
    var gender: String
    var address: String
}

struct DemoView: View {
    let students = [
        Student(name: "John Doe", age: 18, gender: "Male", address: "123 Main St"),
        Student(name: "Jane Smith", age: 17, gender: "Female", address: "456 Oak St"),
        // Thêm các học sinh khác nếu cần
    ]

    var body: some View {
            NavigationView {
                VStack {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        Text("Name").fontWeight(.bold)
                        Text("Age").fontWeight(.bold)
                        Text("Gender").fontWeight(.bold)
                        Text("Address").fontWeight(.bold)

                        ForEach(students, id: \.name) { student in
                            Text(student.name)
                                .frame(minWidth: 0, maxWidth: .infinity / 2, alignment: .leading)
                            Text("\(student.age)")
                                .frame(minWidth: 0, maxWidth: .infinity / 4, alignment: .leading)
                            Text(student.gender)
                                .frame(minWidth: 0, maxWidth: .infinity / 4, alignment: .leading)
                            Text(student.address)
                                .frame(minWidth: 0, maxWidth: .infinity * 2, alignment: .leading)
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Student List")
            }
        }
        

}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}
