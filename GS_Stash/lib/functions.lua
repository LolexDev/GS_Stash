function progressbar(message, time)
    lib.progressCircle({
        duration = time,
        label = message,
        position = 'bottom',
        useWhileDead = false,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false,
        },
    })
end

function obavesti(naslov,deskripcija,type,pozicija,vreme)
    lib.notify({
        title = naslov,
        description = deskripcija,
        type = type,
        position = pozicija,
        duration = vreme,
    })
end

insert = function(t, v)
    t[#t + 1] = v
end