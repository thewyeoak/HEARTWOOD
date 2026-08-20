function interact() {
    var _cuts = cutscene_create()
        ._then(new ev_dialogue([
            dialogue_page("{d,2}(Say..{p,1}. say..{p,1}. \"it didn't happen.\" Say \"it didn't snow.\")", {
                face: dialogue_face(spr_noelle_face, noone, 40),
                blip: snd_blip_noelle
            })
        ]))
        ._then(new ev_choice(["It\nsnew", "It\nhappened"], function(_index, _text) {
            var _page = undefined

            if (_index == 0) {
                _page = dialogue_page("{d,2}What", {
                    face: dialogue_face(spr_noelle_face, noone, 42),
                    blip: snd_blip_noelle
                })
            } else if (_index == 1) {
                _page = dialogue_page("{d,2}... Fuck you,{p,2} Kris.", {
                    face: dialogue_face(spr_noelle_face, noone, 31),
                    blip: snd_blip_noelle
                })
            }
            if (!is_undefined(_page)) {
                global.current_cutscene._then(new ev_dialogue([_page]))
            }
        }))

    cutscene_start(_cuts)
}