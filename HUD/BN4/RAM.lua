-- RAM Functions for MMBN 4 scripting, enjoy.

local ram = require("All/RAM");

ram.addr = require("BN4/Addresses");

ram.version_name = ram.addr.version_name;

-- Necessary to support BN4 non-Wii U versions.
ram.offset_addr = 0x02001550;

ram.previous_ram_offset = 0;

------------------------------ Getters & Setters ------------------------------

ram.track_RAM = function()
    local ram_offset = memory.read_u32_le(ram.offset_addr);

    if ram.previous_ram_offset ~= ram_offset then
        for addr_name,addr in pairs(ram.addr) do
            if type(addr) == "number" and (addr >= 0x02002130 and addr <= 0x02005E20)then
                ram.addr[addr_name] = addr + ram_offset - ram.previous_ram_offset;
            end
        end

        ram.previous_ram_offset = ram_offset;
    end
end

ram.get.pack_ID = function(which_slot) return memory.read_u8(ram.addr.pack_ID+(0x20*which_slot)); end;
ram.set.pack_ID = function(which_slot, chip_ID) memory.write_u8(ram.addr.pack_ID+(0x20*which_slot), chip_ID); end;
ram.get.pack_code = function(which_slot) return memory.read_u8(ram.addr.pack_code+(0x20*which_slot)); end;
ram.set.pack_code = function(which_slot, chip_code) memory.write_u8(ram.addr.pack_code+(0x20*which_slot), chip_code); end;
ram.get.pack_quantity = function(which_slot) return memory.read_u8(ram.addr.pack_quantity+(0x20*which_slot)); end;
ram.set.pack_quantity = function(which_slot, chip_quantity) memory.write_u8(ram.addr.pack_quantity+(0x20*which_slot), chip_quantity); end;

ram.get.check = function() return memory.read_u16_le(ram.addr.check); end;
ram.set.check = function(check) memory.write_u16_le(ram.addr.check, check); end;

ram.get.steps = function() return memory.read_u16_le(ram.addr.steps); end;
ram.set.steps = function(steps) memory.write_u16_le(ram.addr.steps, steps); end;

ram.get.battle_pointer = function() return memory.read_u32_le(ram.addr.battle_pointer); end;
ram.set.battle_pointer = function(battle_pointer) memory.write_u32_le(ram.addr.battle_pointer, battle_pointer); end;

---------------------------------------- RAMsacking ----------------------------------------

function ram.use_fun_flags(fun_flags)
    if fun_flags.always_fullcust then
        ram.set.custom_gauge(0x4000);
    end

    if fun_flags.delete_time_zero then
        ram.set.delete_timer(0);
    end

    if fun_flags.chip_selection_max then
        ram.set.chip_window_size(10);
    elseif fun_flags.chip_selection_one then
        ram.set.chip_window_size( 1);
    end
end

---------------------------------------- Module Controls ----------------------------------------

function ram.initialize(options)
    ram.print_details();
    ram.main_RNG_table = ram.create_RNG_table(0xA338244F, options.maximum_RNG_index);
    ram.lazy_RNG_table = ram.create_RNG_table(0x873CA9E4, options.maximum_RNG_index);
end

function ram.pre_update(options)
    ram.use_fun_flags(options.fun_flags);
    ram.use_fun_flags_common(options.fun_flags);
    ram.expand_RNG_table(ram.main_RNG_table);
    ram.expand_RNG_table(ram.lazy_RNG_table);
end

function ram.post_update(options)
    ram.previous_main_RNG_value = ram.get.main_RNG_value();
    ram.previous_lazy_RNG_value = ram.get.lazy_RNG_value();
end

return ram;

