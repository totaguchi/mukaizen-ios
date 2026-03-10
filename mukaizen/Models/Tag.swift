import Foundation

struct Tag {
    let name: String
    let symbolName: String

    static let defaults: [Tag] = [
        Tag(name: "スポーツ",       symbolName: "figure.run"),
        Tag(name: "無駄な買い物",   symbolName: "cart.fill"),
        Tag(name: "習慣",           symbolName: "repeat"),
        Tag(name: "ゲーム",         symbolName: "gamecontroller.fill"),
    ]

    static func symbolName(for name: String) -> String {
        defaults.first { $0.name == name }?.symbolName ?? "tag"
    }
}
