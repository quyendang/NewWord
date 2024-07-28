//
//  MainView.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView{
            HomeView(lessonViewModel: LessonViewModel())
        }
        .navigationViewStyle(.stack)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
