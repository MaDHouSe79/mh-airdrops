local Translations = {
    target = {
        ['label'] = "Loot Crate",
    },
    info = {
        text = "Airdrop",
        drawtext = "[LEFT ALT] + [R-MOUSE]",
        drawNoAccess = "~r~Access denied~w~",
    },
    notify = {
        airdrop_landed = "Airdrop is geland, ga er snel heen voordat iemand anders het heeft!",
        airprop_caught = "Iemand heeft de airdrop gepakt!",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})