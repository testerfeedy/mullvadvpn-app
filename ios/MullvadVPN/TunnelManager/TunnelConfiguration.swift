// This Source Code Form is subject to the terms of the GPLv3 License.
// You can obtain a copy of the license at https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This file incorporates work covered by the following copyright and
// permission notice:
//
//   Copyright (c) Mullvad VPN AB. All rights reserved.
//
// SPDX-License-Identifier: GPL-3.0-only

import Foundation
import NetworkExtension

struct TunnelConfiguration {
    var isEnabled: Bool
    var localizedDescription: String
    var protocolConfiguration: NETunnelProviderProtocol
    var onDemandRules: [NEOnDemandRule]
    var isOnDemandEnabled: Bool

    init(includeAllNetworks: Bool, excludeLocalNetworks: Bool, isOnDemandEnabled: Bool = true) {
        let protocolConfig = NETunnelProviderProtocol()
        protocolConfig.providerBundleIdentifier = ApplicationTarget.packetTunnel.bundleIdentifier
        protocolConfig.serverAddress = ""
        // IOS16-PATCH: includeAllNetworks (Force all apps / kill switch) доступен только с iOS 17.
        // На iOS 16 делаем fallback: включение этой опции игнорируется, туннель работает без includeAllNetworks.
        // История: до тега ios/2026.2 фича была под #if DEBUG и выкл. по умолчанию — повторяем то поведение на iOS 16.
        if #available(iOS 17, *) {
            protocolConfig.includeAllNetworks = includeAllNetworks
        } else {
            // На iOS 16 includeAllNetworks недоступен — оставляем false (дефолт), чтобы не падать при компиляции.
            // Пользователь увидит, что "Force all apps" работает иначе/хуже (см. docs).
        }
        protocolConfig.excludeLocalNetworks = excludeLocalNetworks

        let alwaysOnRule = NEOnDemandRuleConnect()
        alwaysOnRule.interfaceTypeMatch = .any

        isEnabled = true
        localizedDescription = "WireGuard"
        protocolConfiguration = protocolConfig
        onDemandRules = [alwaysOnRule]
        self.isOnDemandEnabled = isOnDemandEnabled
    }

    func apply(to manager: TunnelProviderManagerType) {
        manager.isEnabled = isEnabled
        manager.localizedDescription = localizedDescription
        manager.protocolConfiguration = protocolConfiguration
        manager.onDemandRules = onDemandRules
        manager.isOnDemandEnabled = isOnDemandEnabled
    }
}
