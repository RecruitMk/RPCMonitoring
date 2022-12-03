local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local active = false
local rpc_incum = 'NULL;'
local rpc_outcum = 'NULL;'
local packet_incum = 'NULL;'
local packet_outcum = 'NULL.'

dt = os.date("%d %B %Y")
timestamp = os.date("%H:%M:%S")
if not doesDirectoryExist(getWorkingDirectory()..'\\RPC') then createDirectory(getWorkingDirectory()..'\\RPC') end

local rpcList = {
    [171] = {
        {name = 'wActorID', type = 'UINT16'}, 
        {name = 'SkinID', type = 'UINT32'}, 
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'Angle', type = 'float'}, 
        {name = 'Health', type = 'float'}, 
        {name = 'Invulnerable', type = 'bool'}, 
    },
    [172] = {
        {name = 'wActorID', type = 'UINT16'}, 
    },
    [173] = {
        {name = 'wActorID', type = 'UINT16'}, 
        {name = 'AnimLibLength', type = 'UINT8'}, 
        {name = 'AnimLib[]', type = 'char'}, 
        {name = 'AnimNameLength', type = 'UINT8'}, 
        {name = 'AnimName[]', type = 'char'}, 
        {name = 'fDelta', type = 'float'}, 
        {name = 'loop', type = 'bool'}, 
        {name = 'lockx', type = 'bool'}, 
        {name = 'locky', type = 'bool'}, 
        {name = 'freeze', type = 'bool'}, 
        {name = 'time', type = 'UINT32'}, 
    },
    [174] = {
        {name = 'wActorID', type = 'UINT16'}, 
    },
    [175] = {
        {name = 'wActorID', type = 'UINT16'}, 
        {name = 'angle', type = 'float'}, 
    },
    [176] = {
        {name = 'wActorID', type = 'UINT16'}, 
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
    },
    [178] = {
        {name = 'wActorID', type = 'UINT16'}, 
        {name = 'health', type = 'float'}, 
    },
    [113] = {
        {name = 'playerid', type = 'UINT16'}, 
        {name = 'Index', type = 'UINT32'}, 
        {name = 'create', type = 'bool'}, 
        {name = 'Model', type = 'UINT32'}, 
        {name = 'bone', type = 'UINT32'}, 
        {name = 'fOffsetX', type = 'float'}, 
        {name = 'fOffsetY', type = 'float'}, 
        {name = 'fOffsetZ', type = 'float'}, 
        {name = 'fRotX', type = 'float'}, 
        {name = 'fRotY', type = 'float'}, 
        {name = 'fRotZ', type = 'float'}, 
        {name = 'fScaleX', type = 'float'}, 
        {name = 'fScaleY', type = 'float'}, 
        {name = 'fScaleZ', type = 'float'}, 
        {name = 'materialcolor1', type = 'INT32'}, 
        {name = 'materialcolor2', type = 'INT32'}, 
    },
    [59] = {
        {name = 'playerid', type = 'UINT16'}, 
        {name = 'color', type = 'UINT32'}, 
        {name = 'drawDistance', type = 'float'}, 
        {name = 'expiretime', type = 'UINT32'}, 
        {name = 'textLength', type = 'UINT8'}, 
        {name = 'text[]', type = 'char'}, 
    },
    [37] = {
        {name = 'playerid', type = 'UINT16'}, 
        {name = 'color', type = 'UINT32'}, 
        {name = 'drawDistance', type = 'float'}, 
        {name = 'expiretime', type = 'UINT32'}, 
        {name = 'textLength', type = 'UINT8'}, 
        {name = 'text[]', type = 'char'},
    },
    [38] = {
        {name = 'type', type = 'UINT8'}, 
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'nextposX', type = 'float'}, 
        {name = 'nextposY', type = 'float'}, 
        {name = 'nextposZ', type = 'float'}, 
        {name = 'radius', type = 'float'}, 
    },
    [39] = {
        {name = 'type', type = 'UINT8'}, 
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'nextposX', type = 'float'}, 
        {name = 'nextposY', type = 'float'}, 
        {name = 'nextposZ', type = 'float'}, 
        {name = 'radius', type = 'float'}, 
    },

    --[[
        SendCommand - 50
        Parameters: UINT32 length, char[] commandtext
    ]]
    [50] = {
        {name = 'length', type = 'UINT32'},
        {name = 'commandtext', type = 'char[]'},
    },

    [101] = {
        {name = 'length', type = 'UINT8'},
        {name = 'ChatMessage', type = 'char[]'},
    },
    --[[
        SendChatMessage - 101
        Parameters: UINT8 length, char[] ChatMessage
    ]]
    [107] = {
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
        {name = 'radius', type = 'float'}, 
    },
    [61] = {
        {name = 'wDialogID', type = 'UINT16'}, 
        {name = 'bDialogStyle', type = 'UINT8'}, 
        {name = 'bTitleLength', type = 'UINT8'}, 
        {name = 'szTitle', type = 'char[]'}, 
        {name = 'bButton1Len', type = 'UINT8'}, 
        {name = 'szButton1', type = 'char[]'}, 
        {name = 'bButton2Len', type = 'UINT8'}, 
        {name = 'szButton2', type = 'char[]'}, 
        {name = 'szInfo', type = 'CSTRING'}, 
    },
    [108] = {
        {name = 'wGangZoneID', type = 'UINT16'}, 
        {name = 'min_x', type = 'float'}, 
        {name = 'min_y', type = 'float'}, 
        {name = 'max_x', type = 'float'}, 
        {name = 'max_y', type = 'float'}, 
        {name = 'color', type = 'UINT32'}, 
    },
    [120] = {
        {name = 'wGangZoneID', type = 'UINT16'}, 
    },
    [121] = {
        {name = 'wGangZoneID', type = 'UINT16'}, 
        {name = 'color', type = 'UINT32'}, 
    },
    [85] = {
        {name = 'wGangZoneID', type = 'UINT16'}, 
    },
    [73] = {
        {name = 'dStyle', type = 'UINT32'}, 
        {name = 'dTime', type = 'UINT32'}, 
        {name = 'dMessageLength', type = 'UINT32'}, 
        {name = 'Message[]', type = 'char'}, 
    },
    [56] = {
        {name = 'bIconID', type = 'UINT8'}, 
        {name = 'posX', type = 'float'}, 
        {name = 'posY', type = 'float'}, 
        {name = 'posZ', type = 'float'}, 
        {name = 'type', type = 'UINT8'}, 
        {name = 'color', type = 'UINT32'}, 
        {name = 'style', type = 'UINT8'}, 
    },
    [144] = {
        {name = 'bIconID', type = 'UINT8'}, 
    },
    [26] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'bIsPassenger', type = 'UINT8'}, 
    },
    [154] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'wVehicleID', type = 'UINT16'}, 
    },
    [57] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'wComponentID', type = 'UINT16'}, 
    },
    [65] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'bInteriorID', type = 'UINT8'}, 
    },
    [70] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'bSeatID', type = 'UINT8'}, 
    },
    [71] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'bSeatID', type = 'UINT8'},
    },
    [106] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'panels', type = 'UINT32'}, 
        {name = 'doors', type = 'UINT32'}, 
        {name = 'lights', type = 'UINT8'}, 
        {name = 'tires', type = 'UINT8'}, 
    },
    [123] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'PlateLength', type = 'UINT8'}, 
        {name = 'PlateText', type = 'char[]'}, 
    },
    [147] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'Health', type = 'float'}, 
    },
    [159] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
    },
    [160] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'Angle', type = 'float'}, 
    },
    [161] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'bObjective', type = 'UINT8'}, 
        {name = 'bDoorsLocked', type = 'UINT8'}, 
    },
    [164] = {
        {name = 'wVehicleID', type = 'INT16'}, 
        {name = 'ModelID', type = 'INT32'}, 
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'Angle', type = 'float'}, 
        {name = 'InteriorColor1', type = 'INT8'}, 
        {name = 'InteriorColor2', type = 'INT8'}, 
        {name = 'Health', type = 'float'}, 
        {name = 'interior', type = 'INT8'}, 
        {name = 'DoorDamageStatus', type = 'INT32'}, 
        {name = 'PanelDamageStatus', type = 'INT32'}, 
        {name = 'LightDamageStatus', type = 'INT8'}, 
        {name = 'tireDamageStatus', type = 'INT8'}, 
        {name = 'addsiren', type = 'INT8'}, 
        {name = 'modslot0', type = 'INT8'}, 
        {name = 'modslot1', type = 'INT8'}, 
        {name = 'modslot2', type = 'INT8'}, 
        {name = 'modslot3', type = 'INT8'}, 
        {name = 'modslot4', type = 'INT8'}, 
        {name = 'modslot5', type = 'INT8'}, 
        {name = 'modslot6', type = 'INT8'}, 
        {name = 'modslot7', type = 'INT8'}, 
        {name = 'modslot8', type = 'INT8'}, 
        {name = 'modslot9', type = 'INT8'}, 
        {name = 'modslot10', type = 'INT8'}, 
        {name = 'modslot11', type = 'INT8'}, 
        {name = 'modslot12', type = 'INT8'}, 
        {name = 'modslot13', type = 'INT8'}, 
        {name = 'PaintJob', type = 'INT8'}, 
        {name = 'BodyColor1', type = 'INT32'}, 
        {name = 'BodyColor2', type = 'INT32'}, 
    },
    [165] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
    },
    [58] = {
        {name = 'wLabelID', type = 'UINT16'}, 
    },
    [94] = {
        {name = 'bHour', type = 'UINT8'}, 
    },
    [170] = {
        {name = 'bEnabled', type = 'bool'}, 
    },
    [134] = {
        {name = 'wTextDrawID', type = 'UINT16'}, 
        {name = 'Flags', type = 'UINT8'}, 
        {name = 'fLetterWidth', type = 'float'}, 
        {name = 'fLetterHeight', type = 'float'}, 
        {name = 'dwLetterColor', type = 'UINT32'}, 
        {name = 'fLineWidth', type = 'float'}, 
        {name = 'fLineHeight', type = 'float'}, 
        {name = 'dwBoxColor', type = 'UINT32'}, 
        {name = 'Shadow', type = 'UINT8'}, 
        {name = 'Outline', type = 'UINT8'}, 
        {name = 'dwBackgroundColor', type = 'UINT32'}, 
        {name = 'Style', type = 'UINT8'}, 
        {name = 'Selectable', type = 'UINT8'}, 
        {name = 'fX', type = 'float'}, 
        {name = 'fY', type = 'float'}, 
        {name = 'wModelID', type = 'UINT16'}, 
        {name = 'fRotX', type = 'float'}, 
        {name = 'fRotY', type = 'float'}, 
        {name = 'fRotZ', type = 'float'}, 
        {name = 'fZoom', type = 'float'}, 
        {name = 'wColor1', type = 'UINT16'}, 
        {name = 'wColor2', type = 'UINT16'}, 
        {name = 'szTextLen', type = 'UINT16'}, 
        {name = 'szText', type = 'char[]'}, 
    },
    [83] = {
        {name = 'color', type = 'UINT32'}, 
        {name = 'enable', type = 'UINT8'}, 
    },
    [105] = {
        {name = 'wTextDrawID', type = 'UINT16'}, 
        {name = 'TextLength', type = 'UINT16'}, 
        {name = 'Text', type = 'char[]'}, 
    },
    [104] = {
        {name = 'enable', type = 'UINT8'}, 
    },
    [126] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'bSpecCamType', type = 'UINT8'}, 
    },
    [127] = {
        {name = 'wVehicleID', type = 'UINT16'}, 
        {name = 'bSpecCamType', type = 'UINT8'}, 
    },
    [68] = {
        {name = 'byteTeam', type = 'UINT8'}, 
        {name = 'iSkin', type = 'INT32'}, 
        {name = 'unk', type = 'UINT8'}, 
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'fRotation', type = 'FLOAT'}, 
        {name = 'iSpawnWeapons1', type = 'INT32'}, 
        {name = 'iSpawnWeapons2', type = 'INT32'}, 
        {name = 'iSpawnWeapons3', type = 'INT32'}, 
        {name = 'iSpawnWeaponsAmmo1', type = 'INT32'}, 
        {name = 'iSpawnWeaponsAmmo2', type = 'INT32'}, 
        {name = 'iSpawnWeaponsAmmo3', type = 'INT32'}, 
    },
    [128] = {
        {name = 'bRequestOutcome', type = 'UINT8'}, 
        {name = 'byteTeam', type = 'UINT8'}, 
        {name = 'iSkin', type = 'INT32'}, 
        {name = 'unk', type = 'UINT8'}, 
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'fRotation', type = 'FLOAT'}, 
        {name = 'iSpawnWeapons1', type = 'INT32'}, 
        {name = 'iSpawnWeapons2', type = 'INT32'}, 
        {name = 'iSpawnWeapons3', type = 'INT32'}, 
        {name = 'iSpawnWeaponsAmmo1', type = 'INT32'}, 
        {name = 'iSpawnWeaponsAmmo2', type = 'INT32'}, 
        {name = 'iSpawnWeaponsAmmo3', type = 'INT32'}, 
    },
    [19] = {
        {name = 'angle', type = 'float'}, 
    },
    [137] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'unknown', type = 'INT32'}, 
        {name = 'isNPC', type = 'UINT8'}, 
        {name = 'PlayerNameLength', type = 'UINT8'}, 
        {name = 'PlayerName', type = 'char[]'}, 
    },
    [138] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'reason', type = 'UINT8'}, 
    },
    [155] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'score', type = 'INT32'}, 
        {name = 'ping', type = 'UINT32'}, 
    },
    [86] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'AnimLibLength', type = 'UINT8'}, 
        {name = 'AnimLib[]', type = 'char'}, 
        {name = 'AnimNameLength', type = 'UINT8'}, 
        {name = 'AnimName[]', type = 'char'}, 
        {name = 'fDelta', type = 'float'}, 
        {name = 'loop', type = 'bool'}, 
        {name = 'lockx', type = 'bool'}, 
        {name = 'locky', type = 'bool'}, 
        {name = 'freeze', type = 'bool'}, 
        {name = 'dTime', type = 'UINT32'}, 
    },
    [87] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
    },
    [166] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
	},
    [11] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'NameLength', type = 'UINT8'}, 
        {name = 'Name', type = 'char[]'}, 
        {name = 'unknown', type = 'UINT8'}, 
    },
    [12] = {
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
    },
    [13] = {
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
    },
    [34] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'dSkillID', type = 'UINT32'}, 
        {name = 'wLevel', type = 'UINT16'}, 
    },
    [153] = {
        {name = 'wPlayerID', type = 'UINT32'}, 
        {name = 'dSkinID', type = 'UINT32'}, 
    },
    [29] = {
        {name = 'bHour', type = 'UINT8'}, 
        {name = 'bSecond', type = 'UINT8'}, 
    },
    [88] = {
        {name = 'bActionID', type = 'UINT8'}, 
    },
    [152] = {
        {name = 'bWeatherID', type = 'UINT8'}, 
    },
    [17] = {
        {name = 'max_x', type = 'float'}, 
        {name = 'min_x', type = 'float'}, 
        {name = 'max_y', type = 'float'}, 
        {name = 'min_y', type = 'float'}, 
    },
    [90] = {
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
    },
    [15] = {
        {name = 'moveable', type = 'UINT8'}, 
    },
    [124] = {
        {name = 'spectating', type = 'UINT32'}, 
    },
    [30] = {
        {name = 'toggle', type = 'UINT8'}, 
    },
    [69] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'bTeamID', type = 'UINT8'}, 
    },
    [16] = {
        {name = 'soundid', type = 'UINT32'}, 
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
    },
    [18] = {
        {name = 'dMoney', type = 'UINT32'}, 
    },
    [20] = {
        {name = 'dMoney', type = 'UINT32'}, 
    },
    [21] = {
        {name = 'dMoney', type = 'UINT32'},
    },
    [22] = {
        {name = 'dWeaponID', type = 'UINT32'}, 
        {name = 'dBullets', type = 'UINT32'}, 
    },
    [41] = {
        {name = 'UrlLength', type = 'UINT8'}, 
        {name = 'Url', type = 'char[]'}, 
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
        {name = 'radius', type = 'float'}, 
        {name = 'UsePos', type = 'UINT8'}, 
    },
    [42] = {
        {name = 'UrlLength', type = 'UINT8'}, 
        {name = 'Url', type = 'char[]'}, 
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
        {name = 'radius', type = 'float'}, 
        {name = 'UsePos', type = 'UINT8'},
    },
    [43] = {
        {name = 'dObjectModel', type = 'UINT32'}, 
        {name = 'x', type = 'float'}, 
        {name = 'y', type = 'float'}, 
        {name = 'z', type = 'float'}, 
        {name = 'radius', type = 'float'}, 
    },
    [14] = {
        {name = 'health', type = 'float'}, 
    },
    [66] = {
        {name = 'armour', type = 'float'}, 
    },
    [145] = {
        {name = 'bWeaponID', type = 'UINT8'}, 
        {name = 'wAmmo', type = 'UINT16'}, 
    },
    [162] = {
        {name = 'bWeaponID', type = 'UINT8'}, 
        {name = 'wAmmo', type = 'UINT16'}, 
    },
    [67] = {
        {name = 'dWeaponID', type = 'UINT32'}, 
    },
    [32] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'team', type = 'uint8'}, 
        {name = 'dSkinId', type = 'UINT32'}, 
        {name = 'PosX', type = 'float'}, 
        {name = 'PosY', type = 'float'}, 
        {name = 'PosZ', type = 'float'}, 
        {name = 'facing_angle', type = 'float'}, 
        {name = 'player_color', type = 'UINT32'}, 
        {name = 'fighting_style', type = 'uint8'}, 
    },
    [163] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
    },
    [79] = {
        {name = 'X', type = 'float'}, 
        {name = 'Y', type = 'float'}, 
        {name = 'Z', type = 'float'}, 
        {name = 'wType', type = 'UINT16'}, 
        {name = 'radius', type = 'float'}, 
    },
    [55] = {
        {name = 'wKillerID', type = 'UINT16'}, 
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'reason', type = 'UINT8'}, 
    },
    [93] = {
        {name = 'dColor', type = 'UINT32'}, 
        {name = 'dMessageLength', type = 'UINT32'}, 
        {name = 'Message', type = 'char[]'}, 
    },
    [35] = {
        {name = 'dDrunkLevel', type = 'UINT32'}, 
    },
    [89] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'fightstyle', type = 'UINT8'}, 
    },
    [156] = {
        {name = 'bInteriorID', type = 'UINT8'}, 
    },
    [72] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'dColor', type = 'UINT32'}, 
    },
    [74] = {
        {name = 'wPlayerID', type = 'UINT16'}, 
        {name = 'dColor', type = 'UINT32'},
    },
    [111] = {
        {name = 'enable', type = 'bool'}, 
    },
    [133] = {
        {name = 'bWantedLevel', type = 'UINT8'}, 
    },
    [157] = {
        {name = 'lookposX', type = 'float'}, 
        {name = 'lookposY', type = 'float'}, 
        {name = 'lookposZ', type = 'float'}, 
    },
    [158] = {
        {name = 'lookposX', type = 'float'}, 
        {name = 'lookposY', type = 'float'}, 
        {name = 'lookposZ', type = 'float'}, 
        {name = 'cutType', type = 'UINT8'}, 
    },

    [115] = {
        {name = 'bGiveOrTake', type = 'bool'},
        {name = 'wPlayerID', type = 'UINT16'},
        {name = 'damage_amount', type = 'float'},
        {name = 'dWeaponID', type = 'UINT32'},
        {name = 'dBodypart', type = 'UINT32'},
    },    
	[11] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
--[[	[12] = {
		{name = 'Packet_ID', type 'UINT8'},
		{name = 'key_length', type 'UINT8'};
		{name = 'key', type 'char[]'};		
	},]]
	[31] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[32] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[33] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[34] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[35] = {
		{name = 'drunk_level', type 'UINT32'},
	},
	[36] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[37] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[38] = {
		{name = 'Packet_ID', type 'UINT8'},
	},
	[200] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'vehicle_id', type = 'UINT16'},
		{name = 'lrkey', type = 'UINT16'},
		{name = 'udkey', type = 'UINT16'},
		{name = 'keys', type = 'UINT16'},
		{name = 'quat_w', type = 'float'},
		{name = 'quat_x', type = 'float'},
		{name = 'quat_y', type = 'float'},
		{name = 'quat_z', type = 'float'},
		{name = 'X', type = 'float'},
		{name = 'Y', type = 'float'},
		{name = 'Z', type = 'float'},
		{name = 'velocity_x', type = 'float'},
		{name = 'velocity_y', type = 'float'},
		{name = 'velocity_z', type = 'float'},	
		{name = 'vehicle_health', type = 'float'},		
		{name = 'player_health', type = 'UINT8'},
		{name = 'player_armour', type = 'UINT8'},
		{name = 'additional_key', type = '2_BITS'},
		{name = 'weapon_id', type = '6_BITS'},
		{name = 'siren_state', type = 'UINT8'},
		{name = 'landing_gear_state', type = 'UINT8'},
		{name = 'trailer_id', type = 'UINT16'},
		{name = 'train_speed', type = 'float'},
	}, 
	[201] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'text_length', type = 'UINT32'},		
		{name = 'cmd_text', type = 'STRING'},
	},
	[203] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'cam_mode', type = 'UINT8'},
		{name = 'cam_front_vec_x', type = 'float'},
		{name = 'cam_front_vec_y', type = 'float'},
		{name = 'cam_front_vec_z', type = 'float'},
		{name = 'cam_pos_x', type = 'float'},
		{name = 'cam_pos_y', type = 'float'},
		{name = 'cam_pos_z', type = 'float'},
		{name = 'aim_z', type = 'float'},
		{name = 'weapon_state', type = '2_BITS'},
		{name = 'cam_zoom', type = '6_BITS'},
		{name = 'aspect_ratio', type = 'UINT8'},
	},
	[204] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'slot_0', type = 'UINT8'},
		{name = 'weapon_0', type = 'UINT8'},
		{name = 'ammo_0', type = 'UINT16'},
		{name = 'slot_1', type = 'UINT8'},
		{name = 'weapon_1', type = 'UINT8'},
		{name = 'ammo_1', type = 'UINT16'},
		{name = 'slot_2', type = 'UINT8'},
		{name = 'weapon_2', type = 'UINT8'},
		{name = 'ammo_2', type = 'UINT16'},
		{name = 'slot_3', type = 'UINT8'},
		{name = 'weapon_3', type = 'UINT8'},
		{name = 'ammo_3', type = 'UINT16'},
		{name = 'slot_4', type = 'UINT8'},
		{name = 'weapon_4', type = 'UINT8'},
		{name = 'ammo_4', type = 'UINT16'},
		{name = 'slot_5', type = 'UINT8'},
		{name = 'weapon_5', type = 'UINT8'},
		{name = 'ammo_5', type = 'UINT16'},
		{name = 'slot_6', type = 'UINT8'},
		{name = 'weapon_6', type = 'UINT8'},
		{name = 'ammo_6', type = 'UINT16'},
		{name = 'slot_7', type = 'UINT8'},
		{name = 'weapon_7', type = 'UINT8'},
		{name = 'ammo_7', type = 'UINT16'},
		{name = 'slot_8', type = 'UINT8'},
		{name = 'weapon_8', type = 'UINT8'},
		{name = 'ammo_8', type = 'UINT16'},
		{name = 'slot_9', type = 'UINT8'},
		{name = 'weapon_9', type = 'UINT8'},
		{name = 'ammo_9', type = 'UINT16'},
		{name = 'slot_10', type = 'UINT8'},
		{name = 'weapon_10', type = 'UINT8'},
		{name = 'ammo_10', type = 'UINT16'},
		{name = 'slot_11', type = 'UINT8'},
		{name = 'weapon_11', type = 'UINT8'},
		{name = 'ammo_11', type = 'UINT16'},
	},
	[205] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'money', type = 'INT32'},
		{name = 'drunk_level', type = 'INT32'},
	},
	[206] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'hit_type', type = 'UINT8'},
		{name = 'hit_id', type = 'UINT16'},
		{name = 'origin_x', type = 'float'},
		{name = 'origin_y', type = 'float'},
		{name = 'origin_z', type = 'float'},
		{name = 'hit_pos_x', type = 'float'},
		{name = 'hit_pos_y', type = 'float'},
		{name = 'hit_pos_z', type = 'float'},
		{name = 'offset_x', type = 'float'},
		{name = 'offset_y', type = 'float'},
		{name = 'offset_z', type = 'float'},
		{name = 'weapon_id', type = 'UINT8'},
	},
	[207] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'lrKey', type = 'UINT16'},
		{name = 'udKey', type = 'UINT16'},
		{name = 'keys', type = 'UINT16'},
		{name = 'X', type = 'float'},
		{name = 'Y', type = 'float'},
		{name = 'Z', type = 'float'},
		{name = 'quat_w', type = 'float'},
		{name = 'quat_x', type = 'float'},
		{name = 'quat_y', type = 'float'},
		{name = 'quat_z', type = 'float'},
		{name = 'health', type = 'UINT8'},
		{name = 'armour', type = 'UINT8'},
		{name = 'additional_key', type = '2_BITS'},
		{name = 'weapon_id', type = '6_BITS'},
		{name = 'special_action', type = 'UINT8'},
		{name = 'velocity_x', type = 'float'},
		{name = 'velocity_y', type = 'float'},
		{name = 'velocity_z', type = 'float'},
		{name = 'surfing_offsets_x', type = 'float'},
		{name = 'surfing_offsets_y', type = 'float'},
		{name = 'surfing_offsets_z', type = 'float'},
		{name = 'surfing_vehicle_id', type = 'UINT16'},
		{name = 'animation_id', type = 'INT16'},
		{name = 'nimation_flags', type = 'INT16'},
	},
	[209] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'vehicle_id', type = 'UINT16'},
		{name = 'seat_id', type = 'UINT8'},
		{name = 'roll_x', type = 'float'},
		{name = 'roll_y', type = 'float'},
		{name = 'roll_z', type = 'float'},
		{name = 'direction_x', type = 'float'},
		{name = 'direction_y', type = 'float'},
		{name = 'direction_z', type = 'float'},
		{name = 'X', type = 'float'},
		{name = 'Y', type = 'float'},
		{name = 'Z', type = 'float'},
		{name = 'angular_velocity_x', type = 'float'},
		{name = 'angular_velocity_x', type = 'float'},
		{name = 'angular_velocity_z', type = 'float'},
		{name = 'vehicle_health', type = 'float'},
	}, 		--{name = '', type = ''},
	[210] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'trailer_id', type = 'UINT16'},
		{name = 'X', type = 'float'},
		{name = 'Y', type = 'float'},
		{name = 'Z', type = 'float'},
		{name = 'quat_x', type = 'float'},
		{name = 'quat_y', type = 'float'},
		{name = 'quat_z', type = 'float'},
		{name = 'velocity_x', type = 'float'},
		{name = 'velocity_y', type = 'float'},
		{name = 'velocity_z', type = 'float'},
		{name = 'angular_velocity_x', type = 'float'},
		{name = 'angular_velocity_y', type = 'float'},
		{name = 'angular_velocity_z', type = 'float'},
	},
	[211] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'vehicle_id', type = 'UINT16'},
		{name = 'drive_by', type = '2_BITS'},
		{name = 'seat_id', type = '6_BITS'},
		{name = 'additional_key', type = '2_BITS'},
		{name = 'weapon_id', type = '6_BITS'},
		{name = 'health', type = 'UINT8'},
		{name = 'armour', type = 'UINT8'},
		{name = 'lrKey', type = 'UINT16'},
		{name = 'udKey', type = 'UINT16'},
		{name = 'keys', type = 'UINT16'},
		{name = 'X', type = 'float'},
		{name = 'Y', type = 'float'},
		{name = 'Z', type = 'float'},
	},
	[212] = {
		{name = 'Packet_ID', type = 'UINT8'},
		{name = 'lrKey', type = 'UINT16'},
		{name = 'udKey', type = 'UINT16'},
		{name = 'keys', type = 'UINT16'},
		{name = 'X', type = 'float'},
		{name = 'Y', type = 'float'},
		{name = 'Z', type = 'float'},
	},
}	

function main()
	if not isSampLoaded() then return end
	while not isSampAvailable() do wait(3500) end
	sampRegisterChatCommand("logger", function()
	active = not active
	sampAddChatMessage('{666666}Logger state {FFFFFF}is '..(active and '{B63A65}ENABLED{666666}!' or '{B63A65}DISABLED{666666}!'), 0xFFFFFFFF)
	end)
end

function convertInfoToText(id, bitStream)
    local bs = readBitStream(id, bitStream)
    local data = ''
    if bs then
        for i = 1, #bs do
            if bs[i] then
                data = data..tostring(bs[i])..(#bs ~= i and ', ' or '')
            end
        end
        data = '['..data..']' 
    else
        data = '()'
    end
    return data
end

function onReceiveRpc(id, bitStream)
	if active then
	rpc_incum = id..' | '..raknetGetRpcName(id)..convertInfoToText(id, bitStream)..';'
		file = io.open(getGameDirectory()..'\\moonloader\\RPC\\'..dt..'.log', 'a')
		file:write('\n['..timestamp..'] _INCOMING_RPC_ID: '..rpc_incum..'')
		file:close()
	end
end

function onSendRpc(id, bitStream)
	if active then
	    rpc_outcum = id..' | '..raknetGetRpcName(id)..convertInfoToText(id, bitStream)..'.'
		file = io.open(getGameDirectory()..'\\moonloader\\RPC\\'..dt..'.log', 'a')
		file:write('\n['..timestamp..'] _OUTCOMING_RPC_ID: '..rpc_outcum..'')
		file:close()
	end
end

function onReceivePacket(id, bitStream)
	if active then
		packet_incum = id..' | '..raknetGetPacketName(id)..convertInfoToText(id, bitStream)..''
		file = io.open(getGameDirectory()..'\\moonloader\\RPC\\'..dt..'.log', 'a')
		file:write('\n['..timestamp..'] _INCOMING_PACKET_ID: '..packet_incum..'')
		file:close()
	end
end

function onSendPacket(id, bitStream)
	if active then
		packet_outcum = id..' | '..raknetGetPacketName(id)..convertInfoToText(id, bitStream)..''
		file = io.open(getGameDirectory()..'\\moonloader\\RPC\\'..dt..'.log', 'a')
		file:write('\n['..timestamp..'] _OUTCOMING_PACKET_ID: '..packet_outcum..'')
		file:close()
	end
end

function readBitStream(id, bs)
    local t = {}
    if rpcList[id] ~= nil then
        local bit = rpcList[id]
        local len = -1
        for i = 1, #bit do
            local name = rpcList[id][i].name
            if name == nil then name = 'UNKNOWN' end
            local type = rpcList[id][i].type
            if type == nil then type = 'unk' end
            local data = 'placeholder'
            if type:lower():find('int8') then
                data = raknetBitStreamReadInt8(bs)
            elseif type:lower():find('int16') then
                data = raknetBitStreamReadInt16(bs)
            elseif type:lower():find('int32') then
                data = raknetBitStreamReadInt32(bs)
            elseif type:lower():find('float') then
                data = raknetBitStreamReadFloat(bs)
			elseif type:lower():find('2_bits') then
				data = raknetBitStreamReadBuffer(bs, data, 2)
			elseif type:lower():find('6_bits') then
				data = raknetBitStreamReadBuffer(bs, data, 6)
            elseif type:lower():find('bool') then
                data = raknetBitStreamReadBool(bs)
            elseif type:lower():find('string') then
                if len ~= -1 then
                    data = '"'..u8(raknetBitStreamReadString(bs, len))..'"'
                else
                    data = 'UNKNOWN LEN'
                end
            elseif type:lower():find('char') then
                data = '"'..u8(raknetBitStreamReadString(bs, len))..'"'  
            else
                data = 'UKNNOWN TYPE '..type:lower()
            end
            if name:lower():find('len') then 
                len = tonumber(data) 
            end
            table.insert(t, data)
        end
        return t
    end
end
