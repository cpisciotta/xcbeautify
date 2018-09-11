extension String: Matchable {
    func match(regex: Regex) -> Bool {
        return regex.match(string: self)
    }
}
