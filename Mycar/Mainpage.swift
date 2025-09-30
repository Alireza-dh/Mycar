//
//  SwiftUIView.swift
//  Mycar
//
//  Created by Alireza on 25/09/2025.
//
import SwiftUI
 var allreportfuel:[reportfuel]=[]

// MARK: - Theme (Blue / White)
private enum MenuTheme {
    static let bg           = Color.white          // menu background
    static let primary      = Color.blue           // normal icons/text
    static let selectedBG   = Color.blue           // selected item background
    static let selectedText = Color.white          // selected item text
    static let normalText   = Color.blue           // normal item text
}

// MARK: - Menu destinations (EN)
enum MenuDestination: String, CaseIterable, Identifiable {
    case home, addCar, fuel, settings, about
    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:     return "Home"
        case .addCar:   return "Add Car"
        case .fuel:     return "Fuel Logs"
        case .settings: return "Settings"
        case .about:    return "About"
        }
    }

    var icon: String {
        switch self {
        case .home:     return "house.fill"
        case .addCar:   return "plus.rectangle.on.folder"
        case .fuel:     return "fuelpump.fill"        // if missing on older iOS, swap to "gauge"
        case .settings: return "gearshape.fill"
        case .about:    return "info.circle.fill"
        }
    }
}

// MARK: - RIGHT Side Menu (drawer opens from RIGHT)
struct SideMenuRight: View {
    @Binding var isOpen: Bool
    @Binding var selection: MenuDestination?
 
    @State private var db = cardb()
    @State private var txtfinalfuel:String=""
    private let width: CGFloat = 280

    var body: some View {
        HStack(spacing: 0) {
            // push menu to the RIGHT
            Spacer(minLength: 0)

            // the menu itself
            VStack(alignment: .leading, spacing: 12) {
                // Header
                HStack(spacing: 10) {
                    Image(systemName: "car.2.fill")
                        .foregroundColor(MenuTheme.primary)
                    Text("My Garage")
                        .font(.title2.bold())
                        .foregroundColor(MenuTheme.primary)
                    Spacer()
                    Button {
                        withAnimation(.spring()) { isOpen = false }
                    } label: {
                        Image(systemName: "xmark")
                            .padding(8)
                            .foregroundColor(MenuTheme.primary)
                    }
                    .contentShape(Rectangle())
                }
                .padding(.bottom, 8)

                // Items
                ForEach(MenuDestination.allCases) { dest in
                    let isSelected = selection == dest
                    Button {
                        selection = dest
                        withAnimation(.spring()) { isOpen = false }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: dest.icon)
                            Text(dest.title)
                            Spacer()
                        }
                        .foregroundColor(isSelected ? MenuTheme.selectedText : MenuTheme.normalText)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? MenuTheme.selectedBG : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                }

                Spacer()

                // Footer action
                Button {
                    // e.g., Sign out action
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Log out")
                    }
                    .foregroundColor(MenuTheme.primary)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
            .padding(16)
            .frame(width: width)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(MenuTheme.bg)
            
        }.onAppear {
           
            allreportfuel=db.getAllreportfuel()
            if allreportfuel.count == 0
                {
              
            }
            else {
            //Alarammassage=("report fuel \(allreportfuel.last!.finalfuel)")
              //  isalert.toggle()
                
                
            }
        
        }
        // hide the drawer off-screen to the RIGHT when closed
        .offset(x: isOpen ? 0 : (width + 24))
        .animation(.spring(), value: isOpen)
    }
}

// MARK: - Main page using RIGHT-side menu
struct Mainpage: View {
    @State private var isMenuOpen = false
    @State private var selection: MenuDestination? = .home

    var body: some View {
        
    
        ZStack {
         
            
            
            // Content
            NavigationView {
                Group {
                    switch selection {
                    case .home:      HomeView()
                    case .addCar:    profile()
                    case .fuel:      Fuel()
                    case .settings:  SettingsView()
                    case .about:     About()
                    case .none:      HomeView()
                    }
                }
                .navigationBarTitle(selection?.title ?? "", displayMode: .inline)
                .navigationBarItems(trailing:      // button on the RIGHT for a RIGHT-side drawer
                    Button {
                        withAnimation(.spring()) { isMenuOpen.toggle() }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(MenuTheme.primary)
                    }
                )
            }
            .zIndex(0)

            // Dimmed backdrop - tap to close
            if isMenuOpen {
                Color.black.opacity(0.3)
                    
                    .onTapGesture {
                        withAnimation(.spring()) { isMenuOpen = false }
                    }
                    .zIndex(1)
            }

            // The RIGHT-side menu
            SideMenuRight(isOpen: $isMenuOpen, selection: $selection)
                .zIndex(2)
        }
        
        
      
        // Swipe to the RIGHT to close (since the drawer is on the right)
        .gesture(
            DragGesture().onEnded { v in
                if isMenuOpen && v.translation.width > 50 {
                    withAnimation(.spring()) { isMenuOpen = false }
                }
            }
        )
    }
}

// MARK: - Sample pages (replace with your real views)
struct HomeView: View      {
    
    var body: some View {
      
        
        VStack(spacing: 30)
        {
           Text("")
            Image("gazeboCar")
                .resizable()
                  .scaledToFit()
                  .clipShape(RoundedRectangle(cornerRadius: 16))
                  .overlay(
                      RoundedRectangle(cornerRadius: 16)
                          .stroke(Color.blue, lineWidth: 3)
                  )
                   .frame(height: 300)
         
            
            if allreportfuel.count==0 {
                Text("Last consumption (L/100 km):").frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
            }
         else {
             Text("Last consumption (L/100 km):\(allreportfuel.last!.finalfuel) km").frame(maxWidth: .infinity)
                 .background(Color.blue)
                 .foregroundColor(.white)
                 .cornerRadius(8)
                 .padding(.horizontal, 20)
                 .bold()
            }
        }.padding(.bottom, 360)
       
        
    }
}
struct AddCarView: View    { var body: some View { Text("Add Car").padding() } }
struct FuelLogsView: View  { var body: some View { Text("Fuel Logs").padding() } }
struct SettingsView: View  { var body: some View { Text("Settings").padding() } }
struct AboutView: View     { var body: some View { Text("About").padding() } }

// MARK: - App entry (remove this if you already have an @main elsewhere)



#Preview {
    Mainpage()
}
