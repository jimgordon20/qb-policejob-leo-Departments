Config = {}

Config.Objects = {
    ["cone"] = {model = `prop_roadcone02a`, freeze = false},
    ["barrier"] = {model = `prop_barrier_work06a`, freeze = true},
    ["roadsign"] = {model = `prop_snow_sign_road_06g`, freeze = true},
    ["tent"] = {model = `prop_gazebo_03`, freeze = true},
    ["light"] = {model = `prop_worklight_03b`, freeze = true},
}

Config.MaxSpikes = 5

Config.FuelScript = "LegacyFuel"

Config.EnableTrahs = false

Config.HandCuffItem = 'handcuffs'

Config.LicenseRank = 2

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'
Config.Debug = false -- Enables DebugPoly

    --Peds
Config.EnablePeds = true -- true: spawns ped at locations/ false: dosen't spawn peds
    --DutyPed
Config.DutyPedScenario = "WORLD_HUMAN_CLIPBOARD_FACILITY" --https://github.com/DioneB/gtav-scenarios
Config.DutyPed = 's_m_y_cop_01' --https://docs.fivem.net/docs/game-references/ped-models/
    --Armory
Config.ArmoryPedScenario = "WORLD_HUMAN_STAND_MOBILE_UPRIGHT_CLUBHOUSE"
Config.ArmoryPed = "s_m_y_swat_01"
    --Garage
Config.GaragePedScenario = "WORLD_HUMAN_AA_SMOKE"
Config.GaragePed = 'mp_m_waremech_01'
    --Helicopter
Config.HeliPedScenario = "WORLD_HUMAN_CLIPBOARD"
Config.HeliPed = 's_m_y_pilot_01'
    --Impound
Config.ImpoundPed = 'ig_tomcasino'
Config.ImpoundPedScenario = "WORLD_HUMAN_CLIPBOARD"
    --Evidence
Config.EvidencePed = 's_m_y_ranger_01'
Config.EvidencePedScenario = "PROP_HUMAN_SEAT_COMPUTER" -- If U change this u nedd to change -1.5 to 1.0 at job.lua/

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
----------------------------------------!ALL LOCATIONS USES GABZ MRPD!-------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
Config.Locations = {
    ["duty"] = {
        [1] = vector4(442.6802, -981.9631, 30.6895, 88.7578), --MRPD
        [2] = vector4(1852.9075, 3688.9360, 34.2670, 205.9638), --BCSO Sandy
    },
    ["vehicle"] = {
        [1] = { --MRPD
            vehped = vector4(441.47, -974.68, 25.7, 175.08),
            vehiclespawn = vector4(445.2, -986.15, 25.7, 265.32)
        },
        [2] = { -- Sandy
            vehped = vector4(1867.3826, 3690.7957, 33.7625, 292.8421),
            vehiclespawn = vector4(1870.12, 3698.43, 33.47, 209.73)
        },
    },
    ["stash"] = { --Personal Stash
        [1] = vector3(461.9494, -999.65, 29.6709), --MRPD
    },
    ["impound"] = {
        [1] = { --MRPD
            vehped = vector4(426.5917, -986.6365, 25.6998, 267.6819),
            vehiclespawn = vector4(425.3405, -989.1127, 25.6998, 267.2135)
        },
        [2] = { -- Sandy
            vehped = vector4(1854.4951, 3700.7144, 34.2653, 25.5320),
            vehiclespawn = vector4(1851.6676, 3707.9885, 33.2954, 30.2172)
        },
    },
    ["helicopter"] = {
        [1] = { --MRPD [helipad ONE]
            vehped = vector4(463.9107, -982.2362, 43.6917, 91.1086),
            vehiclespawn = vector4(449.3762, -981.0111, 43.6914, 91.8346)
        },
        [2] = { --MRPD [helipad 2]
            vehped = vector4(472.9283, -987.9117, 41.0071, 274.7533),
            vehiclespawn = vector4(481.4584, -982.4268, 41.0071, 86.7650)
        },
    },
    ["armory"] = {
        [1] = vector4(480.3087, -996.6514, 30.6896, 89.4523), --MRPD
    },
    ["trash"] = { --Enable or Disablit at line:17
        [1] = vector3(439.0907, -976.746, 30.776),
    },
    ["fingerprint"] = {
        [1] = vector3(474.71, -1013.88, 26.07) 
    },
    ["evidence"] = {
        [1] = vector4(472.5, -990.61, 25.75, 265.05),
    },
    ["stations"] = {
        [1] = {label = "L.S.P.D - Mission Row", coords = vector4(428.23, -984.28, 29.76, 3.5), Sprite = 60, Colour = 29},
        [2] = {label = "BolingBroke", coords = vector4(1845.903, 2585.873, 45.672, 272.249), Sprite = 252, Colour = 54},
        [3] = {label = "B.C.S.O - Sandy", coords = vector4(1853.74, 3685.86, 34.27, 33.64), Sprite = 60, Colour = 28},
    },
}

Config.ArmoryWhitelist = {}


Config.SecurityCameras = {
    hideradar = true,
    cameras = {
        [1] = {label = "Pacific Bank CAM#1", coords = vector3(257.45, 210.07, 109.08), r = {x = -25.0, y = 0.0, z = 28.05}, canRotate = false, isOnline = true},
        [2] = {label = "Pacific Bank CAM#2", coords = vector3(232.86, 221.46, 107.83), r = {x = -25.0, y = 0.0, z = -140.91}, canRotate = false, isOnline = true},
        [3] = {label = "Pacific Bank CAM#3", coords = vector3(252.27, 225.52, 103.99), r = {x = -35.0, y = 0.0, z = -74.87}, canRotate = false, isOnline = true},
        [4] = {label = "Limited Ltd Grove St. CAM#1", coords = vector3(-53.1433, -1746.714, 31.546), r = {x = -35.0, y = 0.0, z = -168.9182}, canRotate = false, isOnline = true},
        [5] = {label = "Rob's Liqour Prosperity St. CAM#1", coords = vector3(-1482.9, -380.463, 42.363), r = {x = -35.0, y = 0.0, z = 79.53281}, canRotate = false, isOnline = true},
        [6] = {label = "Rob's Liqour San Andreas Ave. CAM#1", coords = vector3(-1224.874, -911.094, 14.401), r = {x = -35.0, y = 0.0, z = -6.778894}, canRotate = false, isOnline = true},
        [7] = {label = "Limited Ltd Ginger St. CAM#1", coords = vector3(-718.153, -909.211, 21.49), r = {x = -35.0, y = 0.0, z = -137.1431}, canRotate = false, isOnline = true},
        [8] = {label = "24/7 Supermarkt Innocence Blvd. CAM#1", coords = vector3(23.885, -1342.441, 31.672), r = {x = -35.0, y = 0.0, z = -142.9191}, canRotate = false, isOnline = true},
        [9] = {label = "Rob's Liqour El Rancho Blvd. CAM#1", coords = vector3(1133.024, -978.712, 48.515), r = {x = -35.0, y = 0.0, z = -137.302}, canRotate = false, isOnline = true},
        [10] = {label = "Limited Ltd West Mirror Drive CAM#1", coords = vector3(1151.93, -320.389, 71.33), r = {x = -35.0, y = 0.0, z = -119.4468}, canRotate = false, isOnline = true},
        [11] = {label = "24/7 Supermarkt Clinton Ave CAM#1", coords = vector3(383.402, 328.915, 105.541), r = {x = -35.0, y = 0.0, z = 118.585}, canRotate = false, isOnline = true},
        [12] = {label = "Limited Ltd Banham Canyon Dr CAM#1", coords = vector3(-1832.057, 789.389, 140.436), r = {x = -35.0, y = 0.0, z = -91.481}, canRotate = false, isOnline = true},
        [13] = {label = "Rob's Liqour Great Ocean Hwy CAM#1", coords = vector3(-2966.15, 387.067, 17.393), r = {x = -35.0, y = 0.0, z = 32.92229}, canRotate = false, isOnline = true},
        [14] = {label = "24/7 Supermarkt Ineseno Road CAM#1", coords = vector3(-3046.749, 592.491, 9.808), r = {x = -35.0, y = 0.0, z = -116.673}, canRotate = false, isOnline = true},
        [15] = {label = "24/7 Supermarkt Barbareno Rd. CAM#1", coords = vector3(-3246.489, 1010.408, 14.705), r = {x = -35.0, y = 0.0, z = -135.2151}, canRotate = false, isOnline = true},
        [16] = {label = "24/7 Supermarkt Route 68 CAM#1", coords = vector3(539.773, 2664.904, 44.056), r = {x = -35.0, y = 0.0, z = -42.947}, canRotate = false, isOnline = true},
        [17] = {label = "Rob's Liqour Route 68 CAM#1", coords = vector3(1169.855, 2711.493, 40.432), r = {x = -35.0, y = 0.0, z = 127.17}, canRotate = false, isOnline = true},
        [18] = {label = "24/7 Supermarkt Senora Fwy CAM#1", coords = vector3(2673.579, 3281.265, 57.541), r = {x = -35.0, y = 0.0, z = -80.242}, canRotate = false, isOnline = true},
        [19] = {label = "24/7 Supermarkt Alhambra Dr. CAM#1", coords = vector3(1966.24, 3749.545, 34.143), r = {x = -35.0, y = 0.0, z = 163.065}, canRotate = false, isOnline = true},
        [20] = {label = "24/7 Supermarkt Senora Fwy CAM#2", coords = vector3(1729.522, 6419.87, 37.262), r = {x = -35.0, y = 0.0, z = -160.089}, canRotate = false, isOnline = true},
        [21] = {label = "Fleeca Bank Hawick Ave CAM#1", coords = vector3(309.341, -281.439, 55.88), r = {x = -35.0, y = 0.0, z = -146.1595}, canRotate = false, isOnline = true},
        [22] = {label = "Fleeca Bank Legion Square CAM#1", coords = vector3(144.871, -1043.044, 31.017), r = {x = -35.0, y = 0.0, z = -143.9796}, canRotate = false, isOnline = true},
        [23] = {label = "Fleeca Bank Hawick Ave CAM#2", coords = vector3(-355.7643, -52.506, 50.746), r = {x = -35.0, y = 0.0, z = -143.8711}, canRotate = false, isOnline = true},
        [24] = {label = "Fleeca Bank Del Perro Blvd CAM#1", coords = vector3(-1214.226, -335.86, 39.515), r = {x = -35.0, y = 0.0, z = -97.862}, canRotate = false, isOnline = true},
        [25] = {label = "Fleeca Bank Great Ocean Hwy CAM#1", coords = vector3(-2958.885, 478.983, 17.406), r = {x = -35.0, y = 0.0, z = -34.69595}, canRotate = false, isOnline = true},
        [26] = {label = "Paleto Bank CAM#1", coords = vector3(-102.939, 6467.668, 33.424), r = {x = -35.0, y = 0.0, z = 24.66}, canRotate = false, isOnline = true},
        [27] = {label = "Del Vecchio Liquor Paleto Bay", coords = vector3(-163.75, 6323.45, 33.424), r = {x = -35.0, y = 0.0, z = 260.00}, canRotate = false, isOnline = true},
        [28] = {label = "Don's Country Store Paleto Bay CAM#1", coords = vector3(166.42, 6634.4, 33.69), r = {x = -35.0, y = 0.0, z = 32.00}, canRotate = false, isOnline = true},
        [29] = {label = "Don's Country Store Paleto Bay CAM#2", coords = vector3(163.74, 6644.34, 33.69), r = {x = -35.0, y = 0.0, z = 168.00}, canRotate = false, isOnline = true},
        [30] = {label = "Don's Country Store Paleto Bay CAM#3", coords = vector3(169.54, 6640.89, 33.69), r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = false, isOnline = true},
        [31] = {label = "Vangelico Jewelery CAM#1", coords = vector3(-627.54, -239.74, 40.33), r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
        [32] = {label = "Vangelico Jewelery CAM#2", coords = vector3(-627.51, -229.51, 40.24), r = {x = -35.0, y = 0.0, z = -95.78}, canRotate = true, isOnline = true},
        [33] = {label = "Vangelico Jewelery CAM#3", coords = vector3(-620.3, -224.31, 40.23), r = {x = -35.0, y = 0.0, z = 165.78}, canRotate = true, isOnline = true},
        [34] = {label = "Vangelico Jewelery CAM#4", coords = vector3(-622.57, -236.3, 40.31), r = {x = -35.0, y = 0.0, z = 5.78}, canRotate = true, isOnline = true},
    },
}

Config.Helicopters = {
   [3] = {
        ['POLMAV'] = "POLMAV",
        ['SRU - Buzzard'] = "sru2"
    },
}

Config.VehicleTable = {
    ["police"] = { --job name
        ["L.S.P.D"] = {
            [1] = { --job grade
                ['L.S.P.D - Crown Vic'] = "police", -- lable, veh name
                ['2t40 - Q'] = "2t40"
            }, 
            [2] = {
                ['2t40 - Q'] = "2t40"
            },
        },
    },
    ["sheriff"] = {
            ["B.C.S.O"] = {
            [0] = {['B.C.S.O - Crown Vic'] = "sheriff"}
        },
    },
}

Config.WhitelistedVehicles = {}

Config.AmmoLabels = {
    ["AMMO_PISTOL"] = "9x19mm parabellum bullet",
    ["AMMO_SMG"] = "9x19mm parabellum bullet",
    ["AMMO_RIFLE"] = "7.62x39mm bullet",
    ["AMMO_MG"] = "7.92x57mm mauser bullet",
    ["AMMO_SHOTGUN"] = "12-gauge bullet",
    ["AMMO_SNIPER"] = "Large caliber bullet",
}

Config.Radars = {
	vector4(-623.44421386719, -823.08361816406, 25.25704574585, 145.0),
	vector4(-652.44421386719, -854.08361816406, 24.55704574585, 325.0),
	vector4(1623.0114746094, 1068.9924316406, 80.903594970703, 84.0),
	vector4(-2604.8994140625, 2996.3391113281, 27.528566360474, 175.0),
	vector4(2136.65234375, -591.81469726563, 94.272926330566, 318.0),
	vector4(2117.5764160156, -558.51013183594, 95.683128356934, 158.0),
	vector4(406.89505004883, -969.06286621094, 29.436267852783, 33.0),
	vector4(657.315, -218.819, 44.06, 320.0),
	vector4(2118.287, 6040.027, 50.928, 172.0),
	vector4(-106.304, -1127.5530, 30.778, 230.0),
	vector4(-823.3688, -1146.980, 8.0, 300.0),
}

Config.CarItems = {
    [1] = {
        name = "heavyarmor",
        amount = 2,
        info = {},
        type = "item",
        slot = 1,
    },
    [2] = {
        name = "empty_evidence_bag",
        amount = 10,
        info = {},
        type = "item",
        slot = 2,
    },
    [3] = {
        name = "police_stormram",
        amount = 1,
        info = {},
        type = "item",
        slot = 3,
    },
}

Config.Items = {
    label = "Police Armory",
    slots = 30,
    items = {
        [1] = {
            name = "weapon_pistol",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_PI_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 1,
            authorizedJobs = {'leo'}, -- for all leo jobs set {'leo'}, for intivigial jobs {'police', 'sast', 'sheriff'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [2] = {
            name = "weapon_stungun",
            price = 0,
            amount = 1,
            info = {
                serie = "",
            },
            type = "weapon",
            slot = 2,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [3] = {
            name = "weapon_pumpshotgun",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 3,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [4] = {
            name = "weapon_smg",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_SCOPE_MACRO_02", label = "1x Scope"},
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                }
            },
            type = "weapon",
            slot = 4,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [5] = {
            name = "weapon_carbinerifle",
            price = 0,
            amount = 1,
            info = {
                serie = "",
                attachments = {
                    {component = "COMPONENT_AT_AR_FLSH", label = "Flashlight"},
                    {component = "COMPONENT_AT_SCOPE_MEDIUM", label = "3x Scope"},
                }
            },
            type = "weapon",
            slot = 5,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [6] = {
            name = "weapon_nightstick",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 6,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [7] = {
            name = "pistol_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 7,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [8] = {
            name = "smg_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 8,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [9] = {
            name = "shotgun_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 9,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [10] = {
            name = "rifle_ammo",
            price = 0,
            amount = 5,
            info = {},
            type = "item",
            slot = 10,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [11] = {
            name = "handcuffs",
            price = 0,
            amount = 1,
            info = {},
            type = "item",
            slot = 11,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [12] = {
            name = "weapon_flashlight",
            price = 0,
            amount = 1,
            info = {},
            type = "weapon",
            slot = 12,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [13] = {
            name = "empty_evidence_bag",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 13,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [14] = {
            name = "police_stormram",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 14,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [15] = {
            name = "armor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 15,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [16] = {
            name = "radio",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 16,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0, 1, 2, 3, 4, 5}
        },
        [17] = {
            name = "heavyarmor",
            price = 0,
            amount = 50,
            info = {},
            type = "item",
            slot = 17,
            authorizedJobs = {'leo'},
            authorizedJobGrades = {0,1, 2, 3, 4, 5}
        }
    }
}

--TODO
Config.VehicleSettings = {
    ["car1"] = { --- Model name
        ["extras"] = {
            ["1"] = true, -- on/off
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
            ["13"] = true,
        },
		["livery"] = 1,
    },
    ["car2"] = {
        ["extras"] = {
            ["1"] = true,
            ["2"] = true,
            ["3"] = true,
            ["4"] = true,
            ["5"] = true,
            ["6"] = true,
            ["7"] = true,
            ["8"] = true,
            ["9"] = true,
            ["10"] = true,
            ["11"] = true,
            ["12"] = true,
            ["13"] = true,
        },
		["livery"] = 1,
    }
}

--DutyBlip function

function Config.CreateDutyBlips(playerId, playerLabel, playerJob, playerLocation)
    local DutyBlips = {}
    local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
    if not DoesBlipExist(blip) then
        if NetworkIsPlayerActive(playerId) then
            blip = AddBlipForEntity(ped)
        else
            blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
        end

        if playerJob == "police" then -- job name
            Color = 38 --the bilps color
        elseif
           playerJob == "bcso" then
            Color = 52
        elseif
           playerJob == "saspr" then
            Color = 31
        elseif
        playerJob == "ambulance" then
            Color =  1
        else
            Color = 5
        end

        SetBlipSprite(blip, 1)
        ShowHeadingIndicatorOnBlip(blip, true)
        SetBlipRotation(blip, math.ceil(playerLocation.w))
        SetBlipScale(blip, 1.0)
       SetBlipColour(blip, Color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
        DutyBlips[#DutyBlips+1] = blip
    end

    if GetBlipFromEntity(PlayerPedId()) == blip then
        -- Ensure we remove our own blip.
        RemoveBlip(blip)
    end
end
