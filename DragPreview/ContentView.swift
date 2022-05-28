import SwiftUI


struct AppDetail {
    
    let bundleIdentifier: String
    let icon: NSImage
    
    init(bundleIdentifier: String) {
        self.bundleIdentifier = bundleIdentifier
        
        if
            let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier),
            let representation = NSWorkspace.shared.icon(forFile: url.path).bestRepresentation(for: NSRect(x: 0, y: 0, width: 64, height: 64), context: nil, hints: nil)
        {
            self.icon = NSImage(size: representation.size)
            self.icon.addRepresentation(representation)
        } else {
            self.icon = NSApp.applicationIconImage!
        }
    }
    
}


struct ContentView: View {

    @State private var apps: [AppDetail] = [
        AppDetail(bundleIdentifier: "com.apple.Mail"),
        AppDetail(bundleIdentifier: "com.apple.MobileSMS"),
        AppDetail(bundleIdentifier: "com.apple.Safari"),
    ]
    
    var body: some View {
        VStack(alignment: .center) {
            Image(nsImage: apps.first == nil ? NSApp.applicationIconImage! : apps.first!.icon)
                .onDrag {
                    guard
                        let app = apps.first,
                        let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: app.bundleIdentifier)
                    else {
                        return NSItemProvider()
                    }
                                       
                    return NSItemProvider(object: url as NSURL)
                } preview: {
                    Text(apps.first == nil ? "no app" : apps.first!.bundleIdentifier)
                    Image(nsImage: apps.first == nil ? NSApp.applicationIconImage! : apps.first!.icon)
                }
            Button("next") {
                apps.removeFirst()
            }
            .disabled(apps.isEmpty)
        }
        .frame(width: 200, height: 200)
        .padding()
        
    }

}
