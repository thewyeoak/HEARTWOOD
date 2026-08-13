function interact() 
{
    var cuts = cutscene_create()
    switch interacted {
        case 0:
            interacted += 1
            cuts.add_events(
            [
                new ev_dialogue_basic(["{a,y}Please get me out of here.\nI'm scared."])
            ]
            )
            cuts.add_events(
            [
                new ev_dialogue_basic(["{a,y}I don't know who did this to me. I had a family and kids."])
            ]
            )
            cuts.add_events(
            [
                new ev_dialogue_basic(["{a,y}{e,s}{d,1}Wait a minute, aren't you...?"])
            ]
            )
        break
        case 1:
            cuts.add_events(
            [
                new ev_dialogue_basic(["{a,y}{e,s}{d,4}I can't feel my legs."])
            ]
            )
        break
    }
    cutscene_start(cuts)
}