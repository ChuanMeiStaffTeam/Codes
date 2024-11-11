//
//  Enum.swift
//  huanxi
//
//  Created by rslz on 2024/11/11.
//


enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}

enum RefreshingType: Int {
    case RefreshHeaderStateIdle
    case RefreshHeaderStatePulling
    case RefreshHeaderStateRefreshing
    case RefreshHeaderStateAll
}

enum ShartType: Int {
    case none
    case copy
    case wx
    case qq
    case facebook
    case ins
    case whatsapp
}
