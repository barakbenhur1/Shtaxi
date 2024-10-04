//
//  DestanationSearchView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 04/10/2024.
//

import SwiftUI
import Combine

struct DestanationSearchView: View {
    enum SerachField: Int, Hashable {
        case field
    }
    
    let image: String
    let placeHolder: String
    @State var text: String
    let didSelect: (SearchCompletions?) -> ()
    
    @State private var locationService = LocationService()
    
    @FocusState private var focusedField: SerachField?
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    didSelect(nil)
                } label: {
                    Text("⇐")
                        .font(.textHugeBold)
                        .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding(.top, 60)
            
            textField()
                .onReceive(Just(text)) { _ in locationService.update(queryFragment: text) }
                .focused($focusedField,
                         equals: .field)
            
            List {
                Section {
                    ForEach(locationService.completions, id: \.self) { serach in
                        VStack(alignment: .center) {
                            Text(serach.title)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            Text(serach.subTitle)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        .onTapGesture { didSelect(serach) }
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity)
                        .listRowSeparator(.hidden)
//                        .alignmentGuide(.listRowSeparatorTrailing) { d in d[.trailing] }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .listStyle(.grouped)
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 20)
        .background(.white)
        .frame(maxHeight: .infinity)
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .onAppear {
            focusedField = .field
            locationService.update(queryFragment: text)
        }
    }
    
    @ViewBuilder private func textField() -> some View {
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 24)
                .frame(width: 24)
                .padding(.leading, 24)
                .padding(.trailing, 4)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                }
                .foregroundColor(.secondary)
                .padding(.trailing, 4)
                .frame(height: 18)
                .frame(width: 18)
            }
            
            TextField(placeHolder,
                      text: $text)
            .font(.textMedium)
            .multilineTextAlignment(.trailing)
            .autocorrectionDisabled()
            .padding(.trailing, 24)
        }
        .frame(height: 52)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.infoText,
                        lineWidth: 1)
        )
    }
}

//#Preview {
//    DestanationSearchView()
//}
