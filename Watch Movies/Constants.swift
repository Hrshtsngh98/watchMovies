//
//  Constants.swift
//  Watch Movies
//
//  Created by Harshit Singh on 11/28/17.
//  Copyright © 2017 Harshit Singh. All rights reserved.
//

import Foundation


let apiKey = "be1d80ee6141051acf58cdf374797150"

let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZTFkODBlZTYxNDEwNTFhY2Y1OGNkZjM3NDc5NzE1MCIsInN1YiI6IjVhMWRlMDZlMGUwYTI2NGNjODA3MjliNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.P6RLtAyuqxODl8B8Y6txCZHDXZhOrtqrbfYNJ31VOK4"


let baseUrl = "https://api.themoviedb.org/3/search/movie?"

func getMovieSearchUrl(name: String, page: Int) -> URL {
    var urlStr = "\(baseUrl)api_key=\(apiKey)&language=en-US&query=\(name)&page=\(page)"
    urlStr = urlStr.replacingOccurrences(of: " ", with: "%20")
    let url = URL(string: urlStr)
    return url!;
}
