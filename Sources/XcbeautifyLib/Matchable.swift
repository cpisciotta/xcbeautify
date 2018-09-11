protocol Matchable {
    func match(regex: Regex) -> Bool
}

func ~=<T: Matchable>(regex: Regex, matchable: T) -> Bool {
    return matchable.match(regex: regex)
}
