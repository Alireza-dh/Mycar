//
//  SwiftUIView.swift
//  Mycar
//
//  Created by Alireza on 25/09/2025.
//

import SwiftUI
private enum MenuTheme {
    static let bg           = Color.white          // menu background
    static let primary      = Color.blue           // normal icons/text
    static let selectedBG   = Color.blue           // selected item background
    static let selectedText = Color.white          // selected item text
    static let normalText   = Color.blue           // normal item text
}
struct About: View {
    @Environment(\.openURL) private var openURL

    // App metadata
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "MyCar"
    }
    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    private var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    private var phoneURL: URL? {
        URL(string: "tel://\(phoneNo)")
    }
    private var versionString: String { "Version \(version) (\(build))" }

    // Links (replace with your real URLs)
    private let websiteURL  = URL(string: "https://www.linkedin.com/in/alireza-doosthosseini-055b572a5/")
    private let githubURL   = URL(string: "https://github.com/Alireza-dh")
    private let privacyURL  = URL(string: "mailto:ar.dosthoseini@gmail.com")
    private let emailURL    = URL(string: "mailto:ar.dosthoseini@gmail.com")
    private let phoneNo   = "+4591821563"
    // support email

    var body: some View {
        List {
            // Header
            Section {
                VStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(MenuTheme.primary.opacity(0.12))
                            .frame(width: 88, height: 88)
                        Image(systemName: "car.2.fill")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(MenuTheme.primary)
                    }
                    Text(appName)
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    Text(versionString)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            // About text
            Section(header: Text("About")) {
                Text("MyCar helps you manage your vehicles, save fuel logs, and keep track of inspection dates in a simple, privacy-friendly way")
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Links
            Section(header: Text("Links")) {
                if let url = websiteURL {
                    LinkRow(icon: "globe", title: "Website", url: url)
                }
                if let url = githubURL {
                    LinkRow(icon: "chevron.left.slash.chevron.right", title: "GitHub", url: url)
                }
                if let url = privacyURL {
                    LinkRow(icon: "hand.raised.fill", title: "Privacy Policy", url: url)
                }
            }

            // Contact
            Section(header: Text("Contact")) {
                if let url = emailURL {
                    LinkRow(icon: "envelope.fill", title: "Email Support", url: url)
                }
                
                     

                    if let url = phoneURL {
                        LinkRow(icon: "phone.fill",
                                title: "Call: \(phoneNo)",
                                url: url)
                    }
            }

            // Actions
            Section {
                Button {
                    rateOnAppStore()
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .frame(width: 24)
                        Text("Rate on the App Store")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                .foregroundColor(MenuTheme.normalText)
            } footer: {
                Text("© \(Calendar.current.component(.year, from: Date())) Your Name. All rights reserved.")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .tint(MenuTheme.primary)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func rateOnAppStore() {
        // Replace with your real App Store URL
        if let url = URL(string: "https://apps.apple.com/app/id0000000000?action=write-review") {
            openURL(url)
        }
    }
}

// Reusable link row with chevron
struct LinkRow: View {
    let icon: String
    let title: String
    let url: URL

    var body: some View {
        Link(destination: url) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                    .foregroundColor(MenuTheme.primary)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .foregroundColor(MenuTheme.normalText)
    }
}


#Preview {
    About()
}
