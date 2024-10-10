//
//  RideSuggestionView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 06/10/2024.
//

import SwiftUI

struct RideSuggestionView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var vmProvider: ViewModelProvider
    
    @FetchRequest(sortDescriptors: []) private var profiles: FetchedResults<Profile>
    
    private var vm: MapViewViewModel { return vmProvider.viewModel() }
    
    @State private var filterOptions: [[FilterCell]] = [
        [
            .init(image: "price",
                  text: "מחיר".localized())
        ],
        [
            .init(image: "mFrindes",
                  text: "חברים משותפים".localized())
        ],
        [
            .init(image: "time",
                  text: "שעת איסוף".localized())
        ],
        [
            .init(image: "rating",
                  text: "דירוג".localized())
        ]
    ]
    
    @State private var filters: [String] = []
    
    let from: TripBody
    let to: TripBody
    let number: Int
    let searchFilters: [String]
    
    var body: some View {
        VStack {
            HStack {
                ButtonWithShadow(image: "back",
                                 didSelect: { router.navigateBack() })
                Spacer()
            }
            .padding(.top, 56)
            .padding(.leading, 40)
            .padding(.bottom, 10)
            
            HStack {
                Spacer()
                RightText(text: "הצעות נסיעה".localized(),
                          font: .text24Bold)
            }
            .padding(.leading, 28)
            .padding(.trailing, 28)
            .padding(.bottom, 20)
            
            TableView(diraction: .horizontal,
                      items: $filterOptions) { item in
                guard let axis = getIndexFor(cell: item) else { return }
                filterOptions[axis.0][axis.1].selected.toggle()
                if filterOptions[axis.0][axis.1].selected {
                    filters.append(filterOptions[axis.0][axis.1].text)
                }
                else {
                    guard let at = filters.firstIndex(of: filterOptions[axis.0][axis.1].text) else { return }
                    filters.remove(at: at)
                }
            }
                      .defaultScrollAnchor(.trailing)
                      .scrollClipDisabled(true)
                      .padding(.leading, 28)
                      .padding(.trailing, 28)
                      .frame(height: 38)
            
            ZStack {
                Color.gBlue
                
                HStack(spacing: 4) {
                    Button(action: {
                        guard let id = profiles.first?.userID else { return }
                        vm.newTrip(id: id,
                                   fromBody: from,
                                   toBody: to,
                                   number: number,
                                   complition: { router.navigateBack() },
                                   error: { error in print(error) })
                    }, label: {
                        Image("plus-square")
                            .resizable()
                            .frame(height: 36)
                            .frame(width: 36)
                    })
                    
                    VStack {
                        HStack {
                            Spacer()
                            RightText(text: "ההצעות נסיעה לא מתאימות לך?".localized(),
                                      font: .textMediumBold)
                        }
                        
                        HStack {
                            Spacer()
                            RightText(text: "אפשר להציע נסיעה ליעד שלך".localized(),
                                      font: .text14)
                        }
                    }
                }
                .padding(.vertical, 33.5)
                .padding(.horizontal, 20)
            }
            .frame(height: 119)
            .cornerRadius(12, corners: .allCorners)
            .padding(.top, 32)
            .padding(.leading, 28)
            .padding(.trailing, 28)
            
            Spacer()
        }
    }
    
    private func getIndexFor(cell: FilterCell) -> (Int, Int)? {
        for i in 0..<filterOptions.count {
            for j in 0..<filterOptions[i].count {
                if cell == filterOptions[i][j] { return (i, j) }
            }
        }
        
        return nil
    }
}

//#Preview {
//    RideSuggestionView()
//}
