function interact() {
    var cuts = cutscene_create()
        .add_events(
            [
                new ev_dialogue_basic(["It seems to be some kind of sign for {e,ud}{c,gr}annoying rooms."])
            ]
        )
    cutscene_start(cuts)
}