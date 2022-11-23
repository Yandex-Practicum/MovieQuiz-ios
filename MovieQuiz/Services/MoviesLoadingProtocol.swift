protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<[OneMovie], Errors>) -> Void)
}
