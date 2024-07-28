//
//  SwiftUIView.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 13/12/2023.
//


import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // Video player placeholder
                    ZStack {
                        Rectangle()
                            .foregroundColor(.gray)
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                    }
                    .aspectRatio(16/9, contentMode: .fit)

                    // Project title and creator
                    Text("FREDERICK DOUGLASS: PORTRAIT OF A FREE MAN")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("by Thornwillow")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    // Description text
                    Text("Renowned critic, filmmaker, and historian Henry Louis Gates Jr. brings us a new book on the life and legacy of Frederick Douglass.")
                        .font(.body)
                        .padding(.top, 5)

                    NavigationLink(destination: Text("Campaign Details")) {
                        Text("Read more about the campaign")
                    }

                    // Progress bar
                    ProgressView(value: 42164, total: 50000)
                        .accentColor(.green)
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .padding(.vertical)

                    // Funding details
                    HStack {
                        Text("$42,164 pledged of $50,000")
                        Spacer()
                        Text("153 backers")
                    }
                    .font(.caption)

                    // Days to go
                    HStack {
                        Spacer()
                        Text("14 days to go")
                            .font(.caption)
                            .padding(.trailing)
                    }
                }
                .padding()
            }
            .navigationBarTitle("Learn about a creator's story & vision", displayMode: .inline)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
