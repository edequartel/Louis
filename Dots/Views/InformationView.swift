////
////  InformationView.swift
////  Braille
////
////  Created by Eric de Quartel on 14/03/2022.
////
//
//import SwiftUI
//
//struct InformationView: View {
//    @Environment(\.accessibilityVoiceOverEnabled) var voEnabled: Bool
//    
//    @Environment(\.colorScheme) private var colorScheme
//    @Environment(\.locale) private var locale
//    @Environment(\.calendar) private var calendar
//    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
//    
//    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//    
//    
//    var body: some View {
//        
//        NavigationView {
//            VStack {
//                Form {
//                    HStack {
//                        Text("developedBy".localized())
//                            .font(.title)
//                            .modifier(Square(color: .bart_green))
//                    }
//                    
////                    Section(header: Text("Audio")) { //??
////                        NavigationLink(destination: DownloadView()) {
////                            Text("Download "+"languages".localized())
////                            //                            .font(.footnote)
////                        }
////                    }
//                    
//                    Section(header: Text("Links")) {
//                        Link(destination: URL(string: "http://www.bartimeus.nl")!, label: {
//                            Text("www.bartimeus.nl")
//                        })
//                        Link(destination: URL(string: "https://edequartel.github.io/Louis/")!, label: {
//                            Text("louisOnline".localized())
//                            
//                        })
//                        Link(destination: URL(string: "https://vimeo.com/showcase/9833359")!, label: {
//                            Text("instructionVideos".localized())
//                        })
//                    }
//                    
////                    Section(header: Text("Quick help")) {
////                        Text("helpshorttext".localized())
////                    }
////                    .font(.footnote)
//                    
//                    Section(header: Text("App details")) {
//                        Text(version())
//                        Text(locale.description)
////                        Text(voEnabled ? "Voiceover on" : "Voiceover off")
//                    }
//                    .font(.footnote)
//                    
//                    
//                }
//            }
//            .navigationBarTitle(Text("information".localized()), displayMode: .inline)
//            .navigationBarItems(trailing:
//                                    NavigationLink(destination: TestView()) {
//                Image(systemName: "testtube.2")
//                    .accessibilityLabel("test".localized())
//            })
//            .navigationBarItems(trailing:
//                                    NavigationLink(destination: AudioListView()) {
//                Image(systemName: "headphones")
//                    .accessibilityLabel("audio".localized())
//            })
//            .navigationBarItems(leading:
//                                    NavigationLink(destination: TextFieldCursorView()) {
//                Image(systemName: "character.textbox")
//                    .accessibilityLabel("textfield".localized())
//            })
//            
//        }
//        
//        
//    }
//    
//    func version() -> String {
//        let dictionary = Bundle.main.infoDictionary!
//        let version = dictionary["CFBundleShortVersionString"] as! String
//        let build = dictionary["CFBundleVersion"] as! String
//        return "Version \(version) build \(build)"
//    }
//}
//
//
//struct InformationView_Previews: PreviewProvider {
//    static var previews: some View {
//        InformationView()
//    }
//}
//

//
//  ManualView.swift
//  Ravens
//
//  Created by Eric de Quartel on 15/01/2024.
//

import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewContainer

        init(_ parent: WebViewContainer) {
            self.parent = parent
        }
    }
}

struct InformationView: View {
    var body: some View {
        NavigationView {
            WebViewContainer(urlString: "https://edequartel.github.io/Louis/")
        }
    }
}

#Preview {
    InformationView()
}

