function interact() {
    var cuts = cutscene_create()
        .add_events([
            new ev_dialogue([
                {face: {sprite: spr_noelle_face, talk_sprite: noone, image: 40}, 
                blip: snd_blip_noelle, 
                speaker: noone, 
                text: "{d,2}(Say..{p,1}. say..{p,1}. \"it didn't happen.\" Say \"it didn't snow.\")"}
            ])
        ])
        .add_events([
            new ev_choice(["It\nsnew", "It\nhappened"], function(_index, _text) {
                if (_index == 0) {
                    global.current_cutscene.add_events([
                        new ev_dialogue([ 
                            {face: {sprite: spr_noelle_face, talk_sprite: noone, image: 42}, 
                            blip: snd_blip_noelle, 
                            speaker: noone, 
                            text: "{d,2}What"}
                        ])
                    ])
                } else if (_index == 1) {
                    global.current_cutscene.add_events([
                        new ev_dialogue([
                            {face: {sprite: spr_noelle_face, talk_sprite: noone, image: 31}, 
                            blip: snd_blip_noelle, 
                            speaker: noone, 
                            text: "{d,2}... Fuck you,{p,2} Kris."}
                        ])
                    ])
                }
            })
        ])
    cutscene_start(cuts)
}