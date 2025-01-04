extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }

        var mutableSelf = self
        mutableSelf.removeFirst(prefix.count)
        return mutableSelf
    }
}
