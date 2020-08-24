//
//  ContentView.swift
//  MVVMObservedObjects
//
//  Created by Jawad Hussain Farooqui on 25/08/20.
//  Copyright © 2020 Winsights. All rights reserved.
//

import SwiftUI

let apiUrl = "https://someUrl/courses.json"

struct Course: Identifiable, Decodable {
    let id = UUID()
    let name: String
}
class CoursesViewModel: ObservableObject{
    
    @Published var messages = "Messages inside observable object "
    
    @Published var courses: [Course] = [Course(name: "Course 1"), Course(name: "Course 2"), Course(name: "Course 3")]
    
    func changeMessage() {
        self.messages = "changed message"
    }
        
    func fetchCourses() {
        //fetch json and decode and update some array property
        guard let url = URL(string: apiUrl) else {
            return
        }
        URLSession.shared.dataTask(with: url) {
            (data, resp, err) in
            //check error/resp
            
            DispatchQueue.main.async {
                self.courses = try! JSONDecoder().decode([Course].self, from: data!)
            }
        }.resume()
    }
}

struct ContentView: View {
    
    @ObservedObject var coursesVM = CoursesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text(coursesVM.messages)
                
                ForEach(coursesVM.courses) {
                    course in Text(course.name)
                }
            }.navigationBarTitle("Courses")
                .navigationBarItems(trailing: Button(action:{ print("Fetching json data")
                    self.coursesVM.changeMessage()
                    
                }, label: { Text("Fetch Courses")
                
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
