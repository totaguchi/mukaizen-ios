/// 分数を日本語の時間文字列に変換する共通ユーティリティ
/// 例: 0 → "0分", 30 → "30分", 60 → "1時間", 90 → "1時間30分"
func formatMinutes(_ totalMinutes: Int) -> String {
    let hours = totalMinutes / 60
    let minutes = totalMinutes % 60
    if hours > 0 {
        return minutes > 0 ? "\(hours)時間\(minutes)分" : "\(hours)時間"
    }
    return "\(totalMinutes)分"
}
