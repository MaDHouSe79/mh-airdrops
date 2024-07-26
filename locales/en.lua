local Translations = {
    target = {
        ['label'] = "Loot Crate",
    },
    info = {
        text = "Airdrop",
        drawtext = "[LEFT ALT] + [R-MOUSE]",
        drawNoAccess = "~r~Access denied~w~",
        locked = "~r~Locked~w~",
        unlocked = "~g~Unlocked~w~",
    },
    notify = {
        airdrop_landed = "Airdrop has landed, get there quickly before someone else catches it!",
        airprop_caught = "Someone caught the airdrop!",
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
