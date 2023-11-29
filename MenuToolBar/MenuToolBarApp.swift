//
//
//
//
//
//
//                      JAK COS DODACIE TO DOKUMENTOWAC !!! (tu albo na push)
//
//
//
//
//
//
import SwiftUI
import Foundation

@main
struct MenuToolBarApp: App {
    @State var clockemoji = "⏰"
    @State var sleepTime: Int = 0
    @State var timer: Timer? = nil
    
    
    func setSleepTimer(minutes: Int) {
        sleepTime = minutes * 60
        timer?.invalidate() // Invalidate the old timer if it exists
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.sleepTime > 0 {
                self.sleepTime -= 1
            } else {
                self.timer?.invalidate()
                self.timer = nil
                let task = Process()
                task.launchPath = "/bin/sh"
                task.arguments = ["-c", "pmset sleepnow"]
                task.launch()
            }
        }
    }
    
    var body: some Scene {
        MenuBarExtra(clockemoji){
            Text("Sleep in: \(sleepTime/60):\(String(format: "%02d", sleepTime%60))")
                .disabled(true)
            
            Button("5 min 🥱"){
                setSleepTimer(minutes: 5)
            }
            Button("10 min 😴"){
                setSleepTimer(minutes: 10)
            }
            Button("15 min 💤"){
                setSleepTimer(minutes: 15)
            }
            
            Divider()
            
            Button("LPM \(Image(systemName: "battery.100.bolt"))"){
                let applescript = """
            do shell script "sudo pmset -a lowpowermode 0" with administrator privileges
            """
                let process = Process()
                process.arguments = ["-e", applescript]
                process.launchPath = "/usr/bin/osascript"
                process.launch()
                process.waitUntilExit()
            }
            
            
            Button("Quit"){
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
}
