import Foundation
import ScriptingBridge

@objc protocol iTunesApplication {
    @objc optional var currentTrack: iTunesTrack { get }
    @objc optional var playerPosition: Double { get }
    @objc optional func nextTrack()
    @objc optional func previousTrack()
}

@objc protocol iTunesTrack {
    @objc optional var name: String { get }
    @objc optional var artist: String { get }
}

func formatTime(seconds: Double) -> String {
    let minutes = Int(seconds) / 60
    let seconds = Int(seconds) % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

func getCurrentPlayingSong() {
    if let iTunes: AnyObject = SBApplication(bundleIdentifier: "com.apple.Music") {
        if let track = iTunes.currentTrack, let name = track.name, let artist = track.artist, let position = iTunes.playerPosition {
            let formattedTime = formatTime(seconds: position)
            print("\(name) - \(artist) [\(formattedTime)]")
        } else {
            print("No song is currently playing.")
        }
    } else {
        print("Apple Music app is not running.")
    }
}

func skipToNextSong() {
    if let iTunes: AnyObject = SBApplication(bundleIdentifier: "com.apple.Music") {
        iTunes.nextTrack?()
        print("Skipped to the next song.")
    } else {
        print("Apple Music app is not running.")
    }
}

func skipToPreviousSong() {
    if let iTunes: AnyObject = SBApplication(bundleIdentifier: "com.apple.Music") {
        iTunes.previousTrack?()
        print("Skipped to the previous song.")
    } else {
        print("Apple Music app is not running.")
    }
}

enum Command: String {
    case current = "current"
    case next = "next"
    case previous = "previous"
    case c = "c"
    case n = "n"
    case p = "p"
}

func main() {
    let arguments = CommandLine.arguments
    guard arguments.count > 1 else {
        print("Please provide a command: current (c), next (n), previous (p)")
        return
    }

    if let command = Command(rawValue: arguments[1]) {
        switch command {
        case .current, .c:
            getCurrentPlayingSong()
        case .next, .n:
            skipToNextSong()
        case .previous, .p:
            skipToPreviousSong()
        }
    } else {
        print("Invalid command. Please use: current (c), next (n), previous (p)")
    }
}

main()
