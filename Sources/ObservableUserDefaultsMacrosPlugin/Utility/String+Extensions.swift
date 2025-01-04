extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }

        return removingFirst(prefix.count)
    }

    func capitalizingFirstLetter() -> String {
        prefix(1).uppercased() + removingFirst()
    }

    func removingFirst(_ k: Int = 1) -> String {
        var mutableSelf = self
        mutableSelf.removeFirst(k)
        return mutableSelf
    }
}
