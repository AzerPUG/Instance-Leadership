if AZP == nil then AZP = {} end
if AZP.InstanceLeadership == nil then AZP.InstanceLeadership = {} end

AZP.InstanceLeadership.VersionRequest =
{
    ["CL"] = {
        ["AddonName"] = "CheckList",
        ["Position"] = 1
    },
    ["RC"] = {
        ["AddonName"] = "ReadyCheck",
        ["Position"] = 2
    },
    ["IL"] = {
        ["AddonName"] = "Instance Leadership",
        ["Position"] = 3
    },
    ["GV"] = {
        ["AddonName"] = "GreatVault",
        ["Position"] = 4
    },
    ["MG"] = {
        ["AddonName"] = "ManaGement",
        ["Position"] = 5
    }
}

AZP.encounters =
{
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Shriekwing",
        ["id"] = 2398
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Sludgefist",
        ["id"] = 2399
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Artificer Xy'mox",
        ["id"] = 2405
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Lady Inerva Darkvein",
        ["id"] = 2406
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Sire Denathrius",
        ["id"] = 2407
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "The Council of Blood",
        ["id"] = 2412
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Stone Legion Generals",
        ["id"] = 2417
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Hungering Destroyer",
        ["id"] = 2383
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Huntsman Altimor",
        ["id"] = 2418
    },
    {
        ["raid"] = "Castle Nathria",
        ["name"] = "Sun King's Salvation",
        ["id"] = 2402
    }
}