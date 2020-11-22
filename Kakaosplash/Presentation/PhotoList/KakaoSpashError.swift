//
//  KakaoSpashError.swift
//  Kakaosplash
//
//  Created by Nicholas Kim on 2020/11/22.
//

import Foundation

enum KakaosplashError: Error {
  case parsing(description: String)
  case network(description: String)
}
