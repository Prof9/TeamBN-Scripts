-- Specific Sequences of Inputs for MMBN 3 scripting, enjoy.

local setups = require("All/Setups");

setups.delay_bios   = 282+ 5; -- BN 1 + 3
setups.delay_capcom =  31+11; -- BN 1 + 3
setups.delay_title  =  65+16; -- BN 1 + 3

setups.add_setup(setups.group_misc, "TEST BUTTONS", function()
    --setups.soft_reset();
    --setups.hard_reset();
    --setups.CONTINUE(0);
    setups.press_buttons(37+8, "Loading...."); -- area loading varies
    setups.press_buttons( 1, "PRESS START", {Start=true});
end);

local function reset_and_wait(hard, pause, delay)
    if hard then
        setups.hard_reset();
    else
        setups.soft_reset();
    end
    if pause then
        setups.PRESS_START(delay);
        client.pause();
    else
        setups.CONTINUE(delay);
    end
end

local function press_A_on(hard, target_index)
    reset_and_wait(hard, false, target_index - 66);
end

local group_RNG = setups.create_group("RNG Both");
setups.add_setup(group_RNG, " 66 ->  83: First  A",          function() reset_and_wait( true, false,   0); end);
setups.add_setup(group_RNG, " 66 ->  83: First  A  (Soft)",  function() reset_and_wait(false, false,   0); end);
setups.add_setup(group_RNG, " 66 ->  83: First  A  (Pause)", function() reset_and_wait( true,  true,   0); end);
setups.add_setup(group_RNG, " 83 -> 100: 100 Load  (Pause)", function() reset_and_wait( true,  true,  17); end);
setups.add_setup(group_RNG, "100 -> 117: 100 On A  (Pause)", function() reset_and_wait( true,  true,  34); end);
setups.add_setup(group_RNG, "100 -> 117: 100 On A",          function()     press_A_on( true,        100); end);
setups.add_setup(group_RNG, "200 -> 217: 200 On A",          function()     press_A_on( true,        200); end);
setups.add_setup(group_RNG, "300 -> 317: 300 On A",          function()     press_A_on( true,        300); end);

local group_RNG = setups.create_group("RNG US");
setups.add_setup(group_RNG, "101 -> 118: Wind Box  (Pause)", function() reset_and_wait( true,  true,  35); end);
setups.add_setup(group_RNG, "104 -> 121: Wind Box",          function() reset_and_wait( true, false,  38); end);
setups.add_setup(group_RNG, "104 -> 121: Yort Encounter",    function() reset_and_wait( true, false,  38); end);
setups.add_setup(group_RNG, "128 -> 145: CopyMan   (Pause)", function() reset_and_wait( true,  true,  62); end);
setups.add_setup(group_RNG, "129 -> 146: Wind Star (Pause)", function() reset_and_wait( true,  true,  63); end);
setups.add_setup(group_RNG, "132 -> 149: CopyMan",           function() reset_and_wait( true, false,  66); end);
setups.add_setup(group_RNG, "132 -> 149: Wind Star",         function() reset_and_wait( true, false,  66); end);
setups.add_setup(group_RNG, "135 -> 152: Gamble    (Pause)", function() reset_and_wait(false,  true,  69); end);
setups.add_setup(group_RNG, "137 -> 154: Gamble",            function() reset_and_wait(false, false,  71); end);
setups.add_setup(group_RNG, "168 -> 185: IceBall   (Pause)", function() reset_and_wait( true,  true, 102); end);
setups.add_setup(group_RNG, "170 -> 187: IceBall    (Hard)", function() reset_and_wait( true, false, 104); end);
setups.add_setup(group_RNG, "170 -> 187: IceBall    (Soft)", function() reset_and_wait(false, false, 104); end);
setups.add_setup(group_RNG, "229 -> 246: IceBall   (Pause)", function() reset_and_wait( true,  true, 163); end);
setups.add_setup(group_RNG, "232 -> 249: IceBall Slide",     function() reset_and_wait( true, false, 166); end);

local group_RNG = setups.create_group("RNG JP");
setups.add_setup(group_RNG, " 66 ->  83: First  A",          function() reset_and_wait( true, false,   0); end);

local game = require("BN3/Game");

local function print_GMD_1200(GMD_RNG_index, GMD_index)
    local GMDi = GMD_index;
    if GMDi == 31 or GMDi == 32 then
        print(string.format("%04u: OPTIMAL", GMD_RNG_index)); -- 1200z
    elseif 28 <= GMDi and GMDi <= 30 then
        print(string.format("%04u: GOOD", GMD_RNG_index));    --  800z
    elseif 21 <= GMDi and GMDi <= 27 then
        print(string.format("%04u: OKAY", GMD_RNG_index));    --  400z
    else
        print(string.format("%04u: bad", GMD_RNG_index));
    end
end

local function print_GMD_2000(GMD_RNG_index, GMD_index)
    local GMDi = GMD_index;
    if GMDi == 16 or GMDi == 32 then
        print(string.format("%04u: OPTIMAL", GMD_RNG_index)); -- 2000z
    elseif 29 <= GMDi and GMDi <= 31 then
        print(string.format("%04u: GOOD", GMD_RNG_index));    -- 1200z / 800z
    elseif 13 <= GMDi and GMDi <= 15 then
        print(string.format("%04u: OKAY", GMD_RNG_index));    -- 1000z
    else
        print(string.format("%04u: bad", GMD_RNG_index));
    end
end

local function dump_GMDs(index_start, index_end)
    local GMD_data = {};
    
    local GMD_RNG = game.ram.iterate_RNG_capped(0xA338244F, index_start-1, index_end);
    
    savestate.saveslot(0);
    
    for i=index_start,index_end do
        game.set_GMD_RNG(GMD_RNG);
        game.set_main_RNG_value(GMD_RNG);
        local GMD_index = game.get_GMD_index();
        local GMD_RNG_index = game.get_GMD_RNG_index();
        local is_zenny = game.get_GMD_is_zenny();
        setups.press_buttons(3, "GMD Get!", {A=true});
        
        local GMD_value = game.get_GMD_value();
        local GMD_RNG_next = game.get_GMD_RNG();
        local GMD_RNG_delta = game.get_main_RNG_delta();
        local GMD_index_next = game.get_GMD_index();
        
        GMD_data[GMD_RNG_index] = GMD_index;
        print_GMD_1200(GMD_RNG_index, GMD_index);
        
        GMD_data[GMD_RNG_index] = {};
        GMD_data[GMD_RNG_index].index = GMD_index;
        GMD_data[GMD_RNG_index].value = GMD_value;
        GMD_data[GMD_RNG_index].delta = GMD_RNG_delta;
        GMD_data[GMD_RNG_index].next  = GMD_RNG_next;
        GMD_data[GMD_RNG_index].is_zenny = is_zenny;
        
        savestate.loadslot(0);
        GMD_RNG = game.ram.simulate_RNG(GMD_RNG);
    end
    
    --print(GMD_data);
    
    return GMD_data;
end

local function print_GMD_xy_ACDC2(i, GMD_1_xy, GMD_1_yx, GMD_2_xy, GMD_2_yx)
    if GMD_1_xy == 0xFF10 and GMD_1_yx == 0x00B0 and GMD_2_xy == 0xFFB0 and GMD_2_yx == 0x0014 then
        print(string.format("%04u: OPTIMAL", i)); -- shop set
    elseif GMD_1_xy == 0x00F2 and GMD_1_yx == 0xFECC and GMD_2_xy == 0xFF70 and GMD_2_yx == 0xFED4 then
        print(string.format("%04u: GOOD", i)); -- upper set a
    elseif GMD_1_xy == 0x00F2 and GMD_1_yx == 0xFECC and GMD_2_xy == 0xFF74 and GMD_2_yx == 0xFE6A then
        print(string.format("%04u: GOOD", i)); -- upper set b
    else
        print(string.format("%04u: bad", i));
    end
    --print(string.format("%04u: %04X %04X %04X %04X", i, GMD_1_xy, GMD_1_yx, GMD_2_xy, GMD_2_yx));
end

local function dump_GMDs_xy(index_start, index_end)
    local GMD_data = {};
    
    RNG_start = index_start - 20; -- ACDC2 area loading offset
    
    game.set_main_RNG_value(game.ram.iterate_RNG_capped(0xA338244F, RNG_start-1, index_end));
    
    savestate.saveslot(0);
    
    for i=index_start,index_end do
        setups.press_buttons(10, "Movin' on up!", {Up=true});
        setups.press_buttons(28, "Spawning GMD!", {});
        
        local GMD_1_xy = game.ram.get.GMD_1_xy();
        local GMD_1_yx = game.ram.get.GMD_1_yx();
        local GMD_2_xy = game.ram.get.GMD_2_xy();
        local GMD_2_yx = game.ram.get.GMD_2_yx();
        
        GMD_data[i] = {};
        GMD_data.GMD_1_xy = GMD_1_xy;
        GMD_data.GMD_1_yx = GMD_1_yx;
        GMD_data.GMD_2_xy = GMD_2_xy;
        GMD_data.GMD_2_yx = GMD_2_yx;
        print_GMD_xy_ACDC2(i, GMD_1_xy, GMD_1_yx, GMD_2_xy, GMD_2_yx);
        
        savestate.loadslot(0);
        emu.frameadvance();
        savestate.saveslot(0);
    end
    
    --print(GMD_data);
    
    return GMD_data;
end

local function jack_in(hard, pause, delay_title, delay_jackin)
    reset_and_wait(hard, false, delay_title)
    setups.press_buttons(delay_jackin, "waiting on Main RNG...");
    if pause then
        client.pause();
    else
        setups.press_buttons( 1, "Plug in!", {R=true});
    end
end

local function grab_GMD(pause, delay_title, delay_pressA)
    reset_and_wait(true, false, delay_title)
    setups.press_buttons(50, "waiting on control...");
    setups.press_buttons( 1, "GMD Text!", {A=true});
    setups.press_buttons(12, "waiting on Text...");
    setups.press_buttons( 1, "GMD Text!", {B=true});
    setups.press_buttons(35, "waiting on Text...");
    setups.press_buttons(delay_pressA, "waiting on Main RNG...");
    if pause then
        client.pause();
    else
        setups.press_buttons( 1, "GMD Get!", {A=true});
    end
end

local group_GMD = setups.create_group("GMD Reroll US");
setups.add_setup(group_GMD, "M156: GMD First A",       function() grab_GMD(      false,    0,    0); end);
setups.add_setup(group_GMD, "M472: 2000 Frame 1",      function() grab_GMD(      false,  157,  157); end);
setups.add_setup(group_GMD, "M474: 2000 Frame 2",      function() grab_GMD(      false,  158,  157); end);
setups.add_setup(group_GMD, "M472: 2000 Frame 3",      function() grab_GMD(      false,  159,  157); end);
setups.add_setup(group_GMD, "M474: 2000 Frame 4",      function() grab_GMD(      false,  160,  157); end);
setups.add_setup(group_GMD, "M476: 2000 Frame 5",      function() grab_GMD(      false,  161,  157); end);
setups.add_setup(group_GMD, "M478: 2000 Frame 6",      function() grab_GMD(      false,  162,  157); end);
setups.add_setup(group_GMD, "M476: 2000 Frame 7",      function() grab_GMD(      false,  163,  157); end);
setups.add_setup(group_GMD, "M478: 1000 Frame 8",      function() grab_GMD(      false,  164,  157); end);

local group_GMD = setups.create_group("GMD Jackin US");
setups.add_setup(group_GMD, "M319: First  R",          function() jack_in(false, false,    0,   39); end);
setups.add_setup(group_GMD, "M319: First  R  (Pause)", function() jack_in(false,  true,    0,   39); end);
setups.add_setup(group_GMD, "M385: Wind Star",         function() jack_in(false, false,   66,   39); end);
setups.add_setup(group_GMD, "M385: Wind Star No R",    function() reset_and_wait(false, false,  66); end);
setups.add_setup(group_GMD, "M448: Wind Bop",          function() jack_in(false, false,   66,  102); end);
setups.add_setup(group_GMD, "M448: Wind Bop (Pause)",  function() jack_in(false,  true,   66,  102); end);
setups.add_setup(group_GMD, "M466: After 5 (Pause)",   function() jack_in(false,  true,   84,  102); end);
setups.add_setup(group_GMD, "M474: After 5 then Bop",  function() jack_in(false, false,   92,  102); end);

local group_GMD = setups.create_group("GMD Logging");
setups.add_setup(group_GMD, "Print GMDs  150 to 1000", function() dump_GMDs(             150, 1000); end);
setups.add_setup(group_GMD, "Print GMDs 1000 to 2000", function() dump_GMDs(            1000, 2000); end);
setups.add_setup(group_GMD, "Spawn GMDs  120 to  240", function() dump_GMDs_xy(          120,  240); end);
setups.add_setup(group_GMD, "Spawn GMDs  100 to  500", function() dump_GMDs_xy(          100,  500); end);
setups.add_setup(group_GMD, "Spawn GMDs 1000 to 2000", function() dump_GMDs_xy(         1000, 2000); end);

local group_folders = setups.create_group("Folder Edits");

setups.add_setup(group_folders, "Folder  0: Remove All Chips", function()
    for i=1,30 do
        setups.folder_edit_buttons({
            {A=true};
            {A=true};
            {Down=true};
        });
    end
end);

setups.add_setup(group_folders, "Folder  1: Rock, Paper, FlashMan", function()
    setups.folder_edit_buttons({
        {A=true};
        {R=true};
        {R=true};
        {Down=true};
        {Down=true};
        {A=true};
        {L=true};
        {Up=true};
        {A=true};
        {L=true};
        {Down=true};
        {A=true};
        {A=true};
        {Up=true};
        {A=true};
        {A=true};
        {R=true};
        {R=true};
        {R=true};
        {Up=true};
        {Up=true};
        {Up=true};
        {A=true};
        {Down=true};
        {A=true};
        {Up=true};
        {Up=true};
        {A=true};
        {L=true};
        {A=true};
        {Down=true};
        {A=true};
        {L=true};
        {Down=true};
        {A=true};
        {R=true};
        {Down=true};
        {Down=true};
        {A=true};
        {A=true};
        {R=true};
        {A=true};
        {R=true};
        {Down=true};
        {A=true};
        {L=true};
        {A=true};
    });
end);

return setups.groups;

