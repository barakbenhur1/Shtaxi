//
//  SwiftUIView.swift
//  Taxi_MVP
//
//  Created by Barak Ben Hur on 27/06/2024.
//

import SwiftUI
import PhotosUI

struct SingUpView: View {
    @Environment(\.managedObjectContext) var viewContext

    @EnvironmentObject private var router: Router
    
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var gender: String?
    @State private var showImagePicker: Bool = false
    @State private var avatarImage: UIImage?
    @State private var profile: Profile?
    
    let isNew: Bool
    
    private func navigateTo(route: Router.Route) {
        router.navigateTo(route)
    }
    
    // MARK: Core Data Operations
    func saveProfile(name: String, age: String, gender: String, image: UIImage) {
        if profile == nil {
            profile = Profile(context: viewContext)
            profile?.name = name
            profile?.age = age
//            profile?.gender = gender
            profile?.image = avatarImage!.pngData()
        }
        
        do {
            try self.viewContext.save()
            print("Profile saved!")
        } catch {
            print("whoops \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Text("פרטים")
                    .font(.title2)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                HStack {
                    Image(uiImage: (avatarImage ?? UIImage(named: "UserImage"))!)
                        .resizable()
                        .frame(height: 300)
                        .frame(width: 300)
                        .background(.gray)
                        .clipShape(Circle())
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                }
                .padding(.bottom, 40)
                
                HStack {
                    TextField(text: $name) {
                        Text("שם")
                    }
                    .multilineTextAlignment(.trailing)
                    .font(.title)
                    .padding(.top, 4)
                    .padding(.bottom, 4)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                }
                .background(.green)
                .clipShape(Capsule())
                .padding(.bottom, 10)
                
                HStack {
                TextField(text: $age) {
                    Text("גיל")
                }
                .keyboardType(.numberPad)
                .multilineTextAlignment(.trailing)
                .font(.title)
                .padding(.top, 4)
                .padding(.bottom, 4)
                .padding(.leading, 12)
                .padding(.trailing, 12)
            }
            .background(.yellow)
            .clipShape(Capsule())
            .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Menu {
                        Button(action: {
                            gender = "אישה".localized()
                        }, label: {
                            Text("אישה".localized())
                        })
                        
                        Button(action: {
                            gender = "גבר"
                        }, label: {
                            Text("גבר")
                        })
                    } label: {
                        Text(gender ?? "בחר מין")
                            .font(.title)
                            .foregroundStyle(gender == nil ? .gray.opacity(0.6) : .black)
                    }
                    .padding(.top, 4)
                    .padding(.bottom, 4)
                    .padding(.leading, 12)
                    .padding(.trailing, 12)
                }
                .background(.orange)
                .clipShape(Capsule())
                .padding(.bottom, 10)
            }
            
            Spacer()
            
            Button(action: {
                saveProfile(name: name, age: age, gender: gender!, image: avatarImage!)
                if isNew {
                    navigateTo(route: .map)
                }
                else {
                    router.navigateBack()
                }
            }, label: {
                Text(isNew ? "הבא" : "שמור")
                    .font(.title)
            })
            .disabled(name.isEmpty || age.isEmpty || gender == nil || avatarImage == nil)
        }
        .padding(.leading, 40)
        .padding(.trailing, 40)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $showImagePicker) {
            VStack {
                ImagePicker(image: $avatarImage)
            }
        }
        .onAppear {
            Task {
//                name = profiles.last?.name ?? ""
//                age = profiles.last?.age ?? ""
////                gender = profiles.last?.gender ?? nil
//                avatarImage = profiles.last?.image != nil ? UIImage(data: profiles.last!.image!) : nil
            }
        }
    }
}

#Preview {
    SingUpView(isNew: false)
}
