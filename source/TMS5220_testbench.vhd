--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   15:30:00 05/20/2020
-- Design Name:
-- Module Name:   tms5220_tb.vhd
-- Project Name:  tms5220
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: TMS5220
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;


entity tms5220_tb is
end tms5220_tb;

architecture behavior of tms5220_tb is
	--Inputs
	signal I_WSn    : std_logic := '0';
	signal I_RSn    : std_logic := '0';
	signal I_DATA   : std_logic := '0';
	signal I_TEST   : std_logic := '0';
	signal I_DBUS   : std_logic_vector(7 downto 0) := (others => '0');

	--Outputs
	signal CLK      : std_logic;
	signal O_RDYn   : std_logic;
	signal O_INTn   : std_logic;
	signal O_M0     : std_logic;
	signal O_M1     : std_logic;
	signal O_ADD8   : std_logic;
	signal O_ADD4   : std_logic;
	signal O_ADD2   : std_logic;
	signal O_ADD1   : std_logic;
	signal O_ROMCLK : std_logic;
	signal O_T11    : std_logic;
	signal O_IO     : std_logic;
	signal O_PRMOUT : std_logic;
	signal O_DBUS   : std_logic_vector(7 downto 0);
	signal O_SPKR   : signed(13 downto 0);

	signal index    : integer := 0;
	signal count    : integer := 0;
	signal state    : integer := 0;

	constant datalen    : integer := 3660;
	-- speak a long phrase "ces"
	type DATA_ARRAY is array (0 to datalen) of std_logic_vector(7 downto 0);
	constant DATA   : DATA_ARRAY := (
		-- reset chip with a sequence of ten 0xFF writes
		x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
		-- "Speak External" command
		x"60",
		-- speech data follows
		x"80",x"D2",x"11",x"DC",x"54",x"4D",x"52",x"4A",x"B2",x"11",x"53",x"DF",x"98",x"2D",x"2D",x"4E",
		x"8D",x"63",x"62",x"A7",x"34",x"69",x"76",x"B3",x"72",x"1A",x"D2",x"64",x"B0",x"2C",x"D2",x"59",
		x"48",x"B3",x"81",x"B6",x"4A",x"67",x"25",x"29",x"86",x"C3",x"3D",x"A6",x"B4",x"64",x"38",x"16",
		x"0F",x"AB",x"1D",x"80",x"35",x"B7",x"1D",x"B0",x"E7",x"8E",x"03",x"76",x"BF",x"71",x"C0",x"1E",
		x"D7",x"0E",x"58",x"65",x"AB",x"48",x"5D",x"31",x"5B",x"75",x"EC",x"94",x"15",x"4E",x"35",x"6D",
		x"54",x"42",x"5A",x"04",x"4E",x"17",x"2B",x"0D",x"62",x"14",x"D2",x"9D",x"EC",x"38",x"C8",x"4E",
		x"65",x"79",x"9A",x"6A",x"A7",x"70",x"93",x"E5",x"E9",x"8E",x"95",x"CE",x"4C",x"8E",x"35",x"BB",
		x"4E",x"C6",x"54",x"8E",x"62",x"6E",x"CF",x"00",x"3F",x"BA",x"39",x"E0",x"6A",x"CB",x"B2",x"77",
		x"9B",x"E1",x"A6",x"94",x"8C",x"9B",x"58",x"58",x"9A",x"26",x"56",x"BE",x"CC",x"ED",x"CE",x"5A",
		x"C7",x"04",x"66",x"7A",x"19",x"44",x"1B",x"17",x"DA",x"65",x"5A",x"58",x"75",x"42",x"E4",x"BB",
		x"D8",x"72",x"CE",x"09",x"71",x"68",x"14",x"6B",x"D1",x"38",x"C5",x"B1",x"91",x"AF",x"65",x"92",
		x"90",x"C4",x"CA",x"F2",x"1E",x"71",x"42",x"9A",x"1A",x"E9",x"49",x"36",x"0A",x"69",x"99",x"A4",
		x"4B",x"39",x"55",x"ED",x"B9",x"61",x"B6",x"F6",x"12",x"24",x"A4",x"24",x"3E",x"51",x"DD",x"C8",
		x"35",x"92",x"67",x"9A",x"A5",x"45",x"D7",x"2C",x"91",x"AB",x"92",x"04",x"D0",x"D1",x"7C",x"B8",
		x"6A",x"D8",x"0E",x"F1",x"08",x"5A",x"2E",x"ED",x"78",x"14",x"35",x"98",x"9A",x"8E",x"AD",x"52",
		x"54",x"27",x"2A",x"B2",x"0A",x"5D",x"11",x"05",x"65",x"F9",x"B2",x"72",x"79",x"10",x"94",x"1D",
		x"CB",x"3A",x"E4",x"49",x"93",x"5B",x"8F",x"A3",x"91",x"B6",x"AA",x"8A",x"D5",x"2E",x"56",x"DC",
		x"B3",x"3A",x"4D",x"D9",x"5C",x"61",x"F5",x"16",x"3A",x"61",x"F9",x"04",x"35",x"5A",x"E8",x"84",
		x"9C",x"15",x"54",x"EB",x"29",x"55",x"56",x"5A",x"5C",x"B4",x"B7",x"84",x"DB",x"29",x"79",x"B2",
		x"65",x"11",x"1C",x"27",x"55",x"D1",x"B6",x"45",x"60",x"DD",x"D4",x"C4",x"10",x"11",x"22",x"F1",
		x"42",x"1B",x"83",x"87",x"51",x"24",x"31",x"7D",x"30",x"A9",x"C1",x"1D",x"45",x"0C",x"09",x"9B",
		x"65",x"78",x"1C",x"04",x"1C",x"13",x"22",x"80",x"EB",x"CB",x"19",x"F0",x"5C",x"86",x"00",x"BE",
		x"8F",x"50",x"C0",x"33",x"95",x"02",x"F8",x"7A",x"12",x"01",x"5F",x"A7",x"13",x"E0",x"B8",x"2D",
		x"00",x"E4",x"0E",x"47",x"62",x"D9",x"B6",x"5D",x"31",x"02",x"8A",x"CC",x"98",x"4A",x"45",x"F7",
		x"A8",x"3A",x"43",x"A9",x"94",x"23",x"92",x"72",x"AE",x"C5",x"56",x"8E",x"28",x"42",x"71",x"96",
		x"4A",x"D9",x"A2",x"B0",x"FA",x"C6",x"0A",x"55",x"B6",x"AC",x"56",x"2B",x"C9",x"54",x"56",x"73",
		x"47",x"05",x"2D",x"55",x"49",x"23",x"1B",x"6D",x"8C",x"58",x"43",x"9C",x"4D",x"47",x"D0",x"11",
		x"C0",x"8A",x"E9",x"A5",x"EE",x"DA",x"44",x"38",x"5A",x"97",x"7A",x"A8",x"62",x"45",x"5B",x"2C",
		x"80",x"1F",x"B2",x"04",x"F0",x"6B",x"85",x"00",x"7E",x"49",x"17",x"C0",x"2F",x"91",x"2D",x"AA",
		x"32",x"2C",x"B9",x"23",x"8D",x"A8",x"19",x"29",x"D7",x"8E",x"DC",x"E2",x"62",x"B4",x"DC",x"32",
		x"AA",x"8B",x"93",x"C1",x"76",x"F7",x"B8",x"2A",x"F6",x"9A",x"AA",x"22",x"ED",x"B0",x"D8",x"4B",
		x"8F",x"50",x"8F",x"ED",x"92",x"50",x"54",x"33",x"BD",x"75",x"48",x"63",x"66",x"3B",x"B3",x"BA",
		x"29",x"CF",x"45",x"68",x"53",x"16",x"95",x"22",x"67",x"96",x"0D",x"5D",x"54",x"CA",x"14",x"D8",
		x"2E",x"B5",x"76",x"A8",x"A3",x"E7",x"98",x"B0",x"B8",x"A2",x"CB",x"C6",x"C4",x"D4",x"E2",x"88",
		x"B6",x"38",x"75",x"77",x"95",x"A3",x"EA",x"28",x"D4",x"C2",x"DD",x"69",x"28",x"93",x"34",x"09",
		x"EF",x"5A",x"AD",x"AC",x"D9",x"D8",x"75",x"1D",x"B5",x"B2",x"16",x"71",x"CE",x"76",x"D8",x"CA",
		x"5E",x"C4",x"38",x"C7",x"45",x"29",x"7B",x"25",x"95",x"5C",x"87",x"A1",x"1A",x"8D",x"98",x"FD",
		x"55",x"98",x"66",x"44",x"63",x"96",x"B4",x"9A",x"9E",x"D9",x"2A",x"4C",x"32",x"32",x"03",x"D6",
		x"DA",x"60",x"C0",x"6E",x"A9",x"A1",x"1C",x"09",x"45",x"6F",x"44",x"85",x"6A",x"44",x"34",x"B9",
		x"A2",x"69",x"9A",x"28",x"D8",x"C7",x"1B",x"29",x"6B",x"A5",x"94",x"F3",x"34",x"CE",x"A1",x"9F",
		x"CE",x"55",x"55",x"6D",x"33",x"E0",x"96",x"28",x"01",x"BC",x"E1",x"29",x"80",x"E7",x"2B",x"19",
		x"B0",x"75",x"7A",x"2A",x"8B",x"91",x"92",x"58",x"47",x"A9",x"CA",x"9A",x"27",x"BC",x"6C",x"9B",
		x"26",x"6B",x"AE",x"94",x"8C",x"A2",x"BA",x"62",x"D8",x"CD",x"CC",x"89",x"6B",x"93",x"E4",x"CA",
		x"F4",x"D0",x"AE",x"8D",x"42",x"32",x"C2",x"A2",x"B8",x"2E",x"6B",x"E2",x"A8",x"B6",x"1C",x"BA",
		x"EE",x"51",x"A5",x"3B",x"85",x"E9",x"47",x"02",x"D1",x"6D",x"07",x"66",x"98",x"19",x"D1",x"6A",
		x"6D",x"99",x"61",x"36",x"62",x"EA",x"75",x"E4",x"C6",x"59",x"49",x"24",x"C7",x"96",x"9B",x"66",
		x"67",x"A5",x"AE",x"58",x"61",x"99",x"5D",x"0C",x"A7",x"12",x"A6",x"7D",x"0E",x"35",x"EA",x"4C",
		x"14",x"CE",x"39",x"D5",x"B1",x"B3",x"71",x"38",x"E7",x"CD",x"40",x"CB",x"26",x"66",x"5C",x"37",
		x"1C",x"AC",x"E2",x"98",x"61",x"2E",x"37",x"F4",x"8A",x"C3",x"AE",x"F9",x"66",x"9A",x"2C",x"09",
		x"5A",x"E6",x"A9",x"32",x"74",x"29",x"04",x"D8",x"EE",x"5A",x"00",x"DB",x"AC",x"11",x"60",x"D9",
		x"35",x"F5",x"0F",x"D3",x"CC",x"A4",x"A1",x"49",x"DB",x"6D",x"30",x"63",x"84",x"06",x"00",x"00",
		x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"D7",x"CD",x"61",x"85",
		x"15",x"89",x"46",x"DE",x"03",x"97",x"54",x"3B",x"68",x"C5",x"08",x"54",x"1A",x"E5",x"C0",x"94",
		x"49",x"52",x"49",x"A6",x"22",x"57",x"06",x"25",x"19",x"D1",x"B2",x"5A",x"D1",x"A2",x"18",x"FB",
		x"AA",x"18",x"45",x"1F",x"62",x"92",x"E3",x"62",x"14",x"7D",x"B0",x"4A",x"8F",x"83",x"51",x"8C",
		x"26",x"C6",x"5B",x"31",x"46",x"3E",x"2A",x"87",x"6E",x"56",x"1C",x"79",x"8B",x"DC",x"B6",x"65",
		x"73",x"24",x"D5",x"EB",x"D8",x"46",x"AC",x"15",x"95",x"A8",x"ED",x"5D",x"B2",x"47",x"D0",x"12",
		x"57",x"64",x"CB",x"0A",x"FE",x"48",x"69",x"66",x"6E",x"6B",x"5C",x"B3",x"6D",x"45",x"A8",x"13",
		x"03",x"AC",x"7A",x"63",x"80",x"55",x"6F",x"0C",x"B0",x"DA",x"75",x"33",x"A7",x"35",x"73",x"D7",
		x"C6",x"CD",x"2E",x"C6",x"5B",x"35",x"3C",x"27",x"27",x"DA",x"69",x"D2",x"4E",x"5D",x"DC",x"24",
		x"BA",x"D8",x"DB",x"75",x"F3",x"2B",x"B3",x"B4",x"68",x"D7",x"25",x"EC",x"9A",x"55",x"72",x"63",
		x"99",x"B8",x"70",x"36",x"8F",x"B4",x"43",x"52",x"CF",x"C4",x"B2",x"DA",x"8E",x"4B",x"9B",x"45",
		x"B5",x"A8",x"36",x"29",x"1B",x"91",x"58",x"6A",x"53",x"BB",x"7C",x"16",x"24",x"EE",x"4D",x"49",
		x"F2",x"99",x"80",x"35",x"2A",x"31",x"01",x"76",x"CB",x"4E",x"D9",x"CA",x"C2",x"98",x"15",x"BB",
		x"65",x"63",x"08",x"73",x"6D",x"C2",x"91",x"8F",x"65",x"86",x"3E",x"2E",x"46",x"3E",x"9A",x"3A",
		x"56",x"25",x"68",x"C5",x"A8",x"1C",x"D4",x"19",x"A3",x"14",x"A3",x"50",x"62",x"B5",x"0B",x"57",
		x"56",x"0D",x"19",x"D1",x"0E",x"53",x"39",x"03",x"2B",x"BB",x"C7",x"36",x"C0",x"E9",x"33",x"0E",
		x"D8",x"E5",x"C6",x"01",x"AB",x"DD",x"38",x"60",x"8D",x"1B",x"07",x"AC",x"7E",x"63",x"80",x"35",
		x"AE",x"9B",x"DF",x"A3",x"32",x"7B",x"D7",x"1E",x"7E",x"0B",x"62",x"32",x"9D",x"A8",x"05",x"45",
		x"4B",x"44",x"96",x"5D",x"15",x"F5",x"A0",x"AA",x"EA",x"72",x"90",x"3B",x"63",x"9B",x"9A",x"A7",
		x"66",x"C3",x"8A",x"15",x"A1",x"66",x"3B",x"E5",x"CD",x"A9",x"4A",x"54",x"EC",x"52",x"8D",x"24",
		x"46",x"DD",x"09",x"D3",x"38",x"8A",x"98",x"54",x"C7",x"0A",x"CB",x"48",x"EC",x"3C",x"2E",x"45",
		x"AD",x"4D",x"51",x"6B",x"B1",x"63",x"B5",x"36",x"43",x"AD",x"21",x"4E",x"C4",x"52",x"15",x"0D",
		x"17",x"A7",x"62",x"4B",x"92",x"32",x"58",x"D2",x"48",x"CC",x"45",x"51",x"73",x"73",x"2A",x"D6",
		x"57",x"41",x"C5",x"25",x"8E",x"48",x"57",x"B4",x"38",x"3A",x"B7",x"42",x"75",x"B7",x"96",x"E8",
		x"E4",x"08",x"8D",x"C3",x"7B",x"71",x"A8",x"23",x"F4",x"B7",x"D2",x"AD",x"6E",x"8A",x"01",x"00",
		x"4C",x"3E",x"1B",x"31",x"F7",x"D8",x"4A",x"C5",x"A8",x"28",x"BC",x"65",x"31",x"95",x"23",x"B3",
		x"C2",x"B5",x"C4",x"50",x"35",x"47",x"46",x"DB",x"0A",x"54",x"6D",x"15",x"B7",x"77",x"32",x"52",
		x"75",x"50",x"D4",x"36",x"C9",x"42",x"D5",x"5E",x"73",x"E9",x"B4",x"4A",x"57",x"07",x"C3",x"9E",
		x"D6",x"8A",x"4A",x"5D",x"A2",x"A4",x"64",x"CB",x"6C",x"75",x"0B",x"92",x"E6",x"23",x"B9",x"D5",
		x"BD",x"B0",x"53",x"B5",x"A4",x"52",x"F7",x"46",x"AA",x"39",x"96",x"52",x"3D",x"1A",x"AA",x"F6",
		x"DA",x"34",x"F5",x"28",x"A8",x"94",x"EB",x"42",x"AC",x"B3",x"B4",x"B2",x"AB",x"ED",x"32",x"AD",
		x"76",x"A5",x"AA",x"96",x"04",x"B0",x"67",x"27",x"03",x"CE",x"4A",x"0B",x"E5",x"70",x"C8",x"31",
		x"4B",x"3A",x"54",x"23",x"A1",x"E8",x"0E",x"25",x"D7",x"14",x"85",x"D1",x"5D",x"88",x"54",x"A3",
		x"94",x"4C",x"84",x"69",x"36",x"6D",x"E0",x"EA",x"5D",x"E9",x"98",x"01",x"2B",x"94",x"0B",x"E0",
		x"A5",x"30",x"05",x"FC",x"9C",x"A1",x"80",x"5F",x"32",x"14",x"70",x"73",x"66",x"C9",x"8B",x"D4",
		x"48",x"9D",x"48",x"A5",x"88",x"DA",x"63",x"7C",x"2C",x"87",x"2A",x"A9",x"88",x"D6",x"B2",x"24",
		x"DA",x"2C",x"C5",x"DD",x"2C",x"B6",x"69",x"8B",x"64",x"4F",x"F5",x"A8",x"AE",x"49",x"52",x"A2",
		x"BC",x"02",x"AB",x"C6",x"48",x"AD",x"F2",x"92",x"ED",x"DA",x"22",x"31",x"B2",x"8A",x"92",x"EB",
		x"BA",x"41",x"8B",x"69",x"48",x"AE",x"1F",x"0E",x"55",x"B7",x"69",x"9A",x"A1",x"7B",x"54",x"9B",
		x"A2",x"25",x"C6",x"28",x"29",x"33",x"92",x"95",x"1A",x"A3",x"E4",x"4C",x"0D",x"27",x"61",x"A8",
		x"51",x"8D",x"B5",x"62",x"A5",x"A1",x"26",x"77",x"89",x"96",x"95",x"C6",x"12",x"32",x"25",x"4A",
		x"56",x"98",x"8A",x"CD",x"D2",x"48",x"25",x"61",x"29",x"2E",x"93",x"33",x"15",x"BB",x"AD",x"F8",
		x"48",x"C9",x"52",x"1C",x"8E",x"1E",x"BD",x"29",x"CA",x"76",x"B8",x"47",x"B1",x"16",x"AD",x"D8",
		x"66",x"EF",x"BB",x"56",x"43",x"53",x"BB",x"61",x"4C",x"6F",x"D2",x"72",x"25",x"D6",x"5E",x"D4",
		x"9C",x"CA",x"36",x"DA",x"5A",x"20",x"37",x"1E",x"C7",x"A4",x"EC",x"55",x"8B",x"35",x"34",x"8B",
		x"AC",x"D7",x"CC",x"50",x"95",x"CB",x"C6",x"51",x"D2",x"4C",x"2D",x"32",x"00",x"00",x"00",x"00",
		x"00",x"00",x"00",x"00",x"00",x"B0",x"BF",x"5B",x"15",x"63",x"77",x"9C",x"8A",x"EC",x"D4",x"D4",
		x"26",x"B6",x"02",x"AA",x"92",x"50",x"C0",x"8A",x"21",x"0A",x"58",x"A9",x"43",x"01",x"33",x"A6",
		x"A5",x"21",x"55",x"D3",x"08",x"4F",x"53",x"DC",x"52",x"5D",x"3C",x"3C",x"69",x"B3",x"6B",x"49",
		x"51",x"8B",x"BA",x"C3",x"2A",x"CE",x"59",x"23",x"E3",x"38",x"E0",x"EB",x"52",x"05",x"FC",x"B8",
		x"A1",x"80",x"9F",x"DB",x"18",x"F0",x"7D",x"79",x"1A",x"66",x"E8",x"0C",x"31",x"87",x"AD",x"1D",
		x"DE",x"34",x"28",x"6C",x"1E",x"AB",x"3A",x"4B",x"F5",x"B1",x"B5",x"EC",x"1A",x"22",x"A9",x"47",
		x"F2",x"70",x"4A",x"0A",x"97",x"58",x"29",x"C9",x"4D",x"DA",x"92",x"B5",x"1D",x"3B",x"37",x"0A",
		x"6E",x"CD",x"D0",x"E0",x"BC",x"C0",x"B5",x"CD",x"53",x"51",x"F2",x"0B",x"97",x"F2",x"68",x"4B",
		x"2D",x"A8",x"92",x"2B",x"AB",x"23",x"B5",x"28",x"2B",x"EE",x"8E",x"8C",x"1A",x"62",x"1F",x"3D",
		x"5C",x"62",x"8E",x"49",x"4C",x"0F",x"33",x"F6",x"2C",x"26",x"B1",x"5B",x"35",x"A4",x"D2",x"84",
		x"D8",x"2F",x"E6",x"B5",x"68",x"9A",x"92",x"98",x"C5",x"CE",x"B5",x"69",x"49",x"73",x"26",x"DF",
		x"F0",x"46",x"2D",x"CD",x"89",x"BD",x"23",x"52",x"95",x"24",x"05",x"89",x"0A",x"73",x"13",x"92",
		x"E2",x"DC",x"4D",x"D5",x"49",x"88",x"67",x"AA",x"4C",x"37",x"D9",x"69",x"28",x"31",x"55",x"C5",
		x"E3",x"24",x"3F",x"1F",x"8A",x"64",x"9F",x"92",x"82",x"72",x"D1",x"52",x"BC",x"49",x"89",x"6A",
		x"73",x"65",x"F5",x"24",x"2D",x"9D",x"7D",x"BB",x"D2",x"2C",x"2B",x"60",x"AC",x"6D",x"05",x"8C",
		x"B9",x"A3",x"80",x"B9",x"6E",x"0C",x"30",x"D7",x"CD",x"B8",x"67",x"BF",x"AE",x"49",x"CB",x"23",
		x"AA",x"5E",x"CD",x"BC",x"9A",x"8C",x"A8",x"68",x"0B",x"F7",x"9C",x"D2",x"E2",x"AC",x"B3",x"54",
		x"A2",x"4A",x"89",x"A3",x"DE",x"E0",x"90",x"A6",x"29",x"F6",x"AE",x"22",x"8C",x"EB",x"A6",x"38",
		x"A9",x"28",x"49",x"6E",x"1B",x"E2",x"24",x"34",x"BC",x"D5",x"55",x"49",x"8A",x"C8",x"E0",x"CC",
		x"24",x"25",x"2F",x"AA",x"93",x"2C",x"A3",x"96",x"B2",x"C8",x"18",x"B1",x"0C",x"93",x"AA",x"22",
		x"72",x"4D",x"23",x"68",x"AA",x"93",x"EE",x"16",x"8D",x"28",x"A9",x"89",x"6E",x"5A",x"35",x"AC",
		x"A4",x"2E",x"85",x"2E",x"8E",x"B6",x"92",x"FA",x"14",x"AB",x"29",x"DB",x"72",x"EA",x"53",x"CC",
		x"E6",x"98",x"C8",x"A9",x"CF",x"2E",x"46",x"75",x"62",x"A7",x"BF",x"49",x"D3",x"50",x"B6",x"14",
		x"DE",x"69",x"42",x"4D",x"D4",x"B2",x"4B",x"66",x"48",x"73",x"33",x"4B",x"61",x"9A",x"71",x"22",
		x"CC",x"6D",x"31",x"60",x"E5",x"0A",x"06",x"2C",x"D7",x"E1",x"D6",x"69",x"D3",x"5D",x"C5",x"0C",
		x"19",x"1B",x"75",x"8B",x"D0",x"A8",x"A8",x"0D",x"BA",x"32",x"4C",x"9D",x"01",x"F2",x"9B",x"30",
		x"33",x"77",x"A7",x"A8",x"64",x"A9",x"2A",x"94",x"55",x"8B",x"5A",x"D4",x"C8",x"20",x"73",x"A4",
		x"2A",x"13",x"3B",x"99",x"22",x"59",x"AA",x"A2",x"CA",x"4E",x"D6",x"BA",x"AD",x"2A",x"CA",x"32",
		x"34",x"AF",x"B4",x"BA",x"18",x"4B",x"B7",x"99",x"DC",x"EA",x"6C",x"CD",x"3D",x"A7",x"52",x"69",
		x"8A",x"53",x"B7",x"9C",x"9A",x"A5",x"29",x"5A",x"5D",x"EC",x"62",x"A7",x"A6",x"48",x"09",x"D7",
		x"8D",x"14",x"9A",x"86",x"43",x"42",x"73",x"91",x"00",x"9E",x"0E",x"13",x"C0",x"8F",x"A9",x"0C",
		x"F8",x"21",x"DD",x"F4",x"5D",x"B9",x"06",x"F6",x"E2",x"14",x"0C",x"BB",x"D9",x"24",x"B5",x"43",
		x"DE",x"A3",x"39",x"65",x"27",x"2E",x"45",x"CD",x"E2",x"5A",x"9D",x"B0",x"95",x"25",x"89",x"A7",
		x"6F",x"CA",x"52",x"D6",x"28",x"29",x"3A",x"1E",x"55",x"D3",x"92",x"BA",x"71",x"A8",x"42",x"45",
		x"AB",x"11",x"C1",x"E9",x"D5",x"14",x"33",x"65",x"94",x"B9",x"9D",x"52",x"36",x"C9",x"DE",x"56",
		x"51",x"52",x"95",x"58",x"54",x"BB",x"C6",x"15",x"4D",x"10",x"31",x"CE",x"6A",x"57",x"F4",x"D5",
		x"90",x"85",x"6B",x"1C",x"56",x"7B",x"AD",x"1D",x"6E",x"76",x"4C",x"61",x"62",x"B6",x"09",x"2B",
		x"49",x"79",x"D4",x"E9",x"A9",x"5C",x"B5",x"A5",x"35",x"88",x"AB",x"54",x"B5",x"12",x"B7",x"C8",
		x"49",x"39",x"A9",x"5D",x"5C",x"35",x"86",x"A7",x"C7",x"4A",x"F1",x"7C",x"9D",x"6A",x"6A",x"C5",
		x"00",x"AB",x"6D",x"A7",x"7F",x"A6",x"49",x"2F",x"89",x"93",x"82",x"12",x"4C",x"D4",x"23",x"4E",
		x"8A",x"52",x"61",x"9E",x"F0",x"24",x"21",x"89",x"85",x"F9",x"52",x"9B",x"86",x"2C",x"35",x"E2",
		x"35",x"6F",x"EA",x"F2",x"54",x"15",x"D6",x"B5",x"AE",x"28",x"73",x"73",x"68",x"B6",x"A4",x"A8",
		x"A9",x"A1",x"3D",x"58",x"1C",x"A5",x"BA",x"D5",x"89",x"F2",x"74",x"9C",x"DE",x"9E",x"D6",x"43",
		x"4C",x"56",x"4A",x"7A",x"4C",x"31",x"B2",x"3A",x"25",x"AF",x"46",x"25",x"A5",x"23",x"9B",x"32",
		x"4A",x"8E",x"92",x"65",x"6D",x"AA",x"2C",x"30",x"3B",x"CA",x"8A",x"00",x"4E",x"5C",x"17",x"C0",
		x"4F",x"19",x"02",x"F8",x"A1",x"4A",x"00",x"3F",x"67",x"29",x"E0",x"29",x"97",x"E2",x"57",x"25",
		x"9A",x"52",x"73",x"52",x"50",x"34",x"67",x"4A",x"55",x"35",x"41",x"76",x"10",x"EB",x"15",x"C6",
		x"84",x"39",x"40",x"8C",x"8D",x"65",x"13",x"05",x"2F",x"BE",x"EC",x"E1",x"43",x"1C",x"4A",x"D0",
		x"3A",x"4F",x"09",x"69",x"88",x"45",x"D3",x"54",x"BB",x"64",x"31",x"BA",x"6C",x"6B",x"AD",x"96",
		x"A7",x"20",x"3D",x"E6",x"71",x"5A",x"91",x"AC",x"77",x"8B",x"37",x"2D",x"45",x"D4",x"D9",x"4D",
		x"D1",x"24",x"14",x"51",x"76",x"25",x"66",x"BD",x"50",x"24",x"91",x"DD",x"94",x"51",x"5A",x"99",
		x"74",x"56",x"5A",x"C7",x"6E",x"65",x"B5",x"DC",x"E9",x"1D",x"BB",x"55",x"A3",x"1B",x"87",x"D9",
		x"EC",x"D0",x"8E",x"50",x"1D",x"45",x"96",x"D5",x"3D",x"43",x"4E",x"34",x"4B",x"0E",x"D3",x"AC",
		x"5E",x"D5",x"E6",x"A4",x"7D",x"23",x"4E",x"57",x"57",x"EC",x"F6",x"F5",x"30",x"D5",x"65",x"A2",
		x"D3",x"DF",x"42",x"55",x"98",x"39",x"29",x"69",x"CA",x"56",x"AE",x"51",x"65",x"64",x"C5",x"69",
		x"B7",x"79",x"DC",x"96",x"77",x"CB",x"13",x"11",x"96",x"5B",x"DE",x"83",x"34",x"77",x"C4",x"4A",
		x"79",x"F7",x"54",x"14",x"A5",x"B1",x"14",x"2D",x"6A",x"88",x"8C",x"AB",x"56",x"F6",x"CA",x"89",
		x"D5",x"1E",x"52",x"3D",x"16",x"05",x"4C",x"A5",x"10",x"40",x"CF",x"A4",x"0A",x"E8",x"AD",x"52",
		x"01",x"33",x"4F",x"1B",x"60",x"E5",x"59",x"03",x"CC",x"7E",x"6D",x"80",x"39",x"AE",x"0D",x"30",
		x"E7",x"8D",x"01",x"E6",x"B8",x"2E",x"65",x"B3",x"6A",x"EA",x"D1",x"B2",x"D4",x"C5",x"48",x"54",
		x"76",x"98",x"D2",x"65",x"6B",x"D1",x"91",x"71",x"52",x"9F",x"5C",x"44",x"6A",x"D4",x"09",x"7D",
		x"0C",x"19",x"6E",x"51",x"27",x"F4",x"D1",x"65",x"AB",x"E4",x"64",x"D7",x"27",x"93",x"6D",x"AC",
		x"93",x"54",x"1F",x"5D",x"0C",x"53",x"8E",x"36",x"7D",x"B4",x"39",x"46",x"72",x"5B",x"F5",x"3E",
		x"57",x"13",x"C5",x"15",x"D1",x"F8",x"54",x"4D",x"14",x"67",x"48",x"E3",x"CB",x"34",x"72",x"CC",
		x"25",x"BD",x"0B",x"3D",x"42",x"3E",x"87",x"35",x"AE",x"4F",x"30",x"DB",x"6D",x"D1",x"DA",x"DD",
		x"2A",x"62",x"B3",x"55",x"EB",x"7A",x"46",x"A0",x"CE",x"56",x"AD",x"DB",x"49",x"A5",x"BA",x"C8",
		x"74",x"A1",x"27",x"8D",x"F1",x"22",x"D3",x"85",x"1A",x"78",x"CE",x"93",x"5C",x"97",x"86",x"D2",
		x"86",x"34",x"72",x"5D",x"6E",x"86",x"D9",x"E2",x"D6",x"74",x"79",x"2A",x"C9",x"98",x"5D",x"F6",
		x"97",x"D2",x"81",x"E4",x"76",x"D0",x"DF",x"5C",x"A5",x"93",x"CA",x"01",x"00",x"00",x"40",x"7F",
		x"B3",x"E5",x"8A",x"39",x"07",x"01",x"4F",x"65",x"31",x"E0",x"87",x"4C",x"06",x"FC",x"98",x"29",
		x"80",x"9F",x"BA",x"04",x"F0",x"73",x"95",x"00",x"7E",x"AA",x"14",x"C0",x"0F",x"1D",x"02",x"38",
		x"32",x"24",x"25",x"23",x"11",x"8B",x"5F",x"EA",x"94",x"8E",x"8A",x"A4",x"B1",x"9D",x"43",x"36",
		x"2C",x"91",x"75",x"77",x"72",x"E9",x"70",x"48",x"71",x"93",x"08",x"01",x"6B",x"30",x"22",x"60",
		x"1D",x"42",x"04",x"AC",x"89",x"E4",x"8A",x"A1",x"90",x"6B",x"DB",x"91",x"2B",x"A7",x"43",x"F2",
		x"AB",x"58",x"A1",x"9C",x"0E",x"29",x"AE",x"6D",x"87",x"62",x"7A",x"24",x"9B",x"49",x"1C",x"8A",
		x"D9",x"90",x"F5",x"5A",x"B1",x"AB",x"E6",x"51",x"81",x"EE",x"C4",x"64",x"1A",x"95",x"54",x"77",
		x"1B",x"92",x"71",x"EE",x"1A",x"36",x"69",x"1B",x"DE",x"5E",x"25",x"64",x"A3",x"4E",x"6B",x"7A",
		x"E0",x"B4",x"AD",x"D8",x"AD",x"AE",x"4E",x"DA",x"37",x"63",x"B5",x"A6",x"78",x"ED",x"98",x"8C",
		x"5C",x"FA",x"1E",x"B4",x"74",x"A2",x"72",x"9B",x"5A",x"8A",x"E6",x"AA",x"26",x"69",x"6E",x"D1",
		x"9B",x"73",x"52",x"B9",x"B1",x"07",x"1B",x"B5",x"76",x"EC",x"FE",x"6E",x"D3",x"8A",x"3D",x"B6",
		x"00",x"8E",x"74",x"11",x"C0",x"0F",x"16",x"0C",x"F8",x"31",x"9C",x"01",x"BF",x"B8",x"31",x"E0",
		x"C7",x"4C",x"06",x"FC",x"12",x"C5",x"80",x"5F",x"A3",x"18",x"F0",x"4B",x"34",x"02",x"BE",x"A9",
		x"14",x"E6",x"54",x"5F",x"E5",x"1E",x"09",x"3D",x"3D",x"4C",x"A5",x"66",x"12",x"00",x"00",x"00",
		x"00",x"00",x"00",x"00",x"00",x"E4",x"8E",x"92",x"1D",x"92",x"59",x"42",x"DA",x"82",x"25",x"67",
		x"DB",x"6C",x"79",x"4F",x"D6",x"E8",x"99",x"B0",x"14",x"CD",x"72",x"B1",x"B5",x"C2",x"90",x"47",
		x"A5",x"AE",x"3A",x"2A",x"53",x"56",x"8C",x"3A",x"DB",x"31",x"6C",x"69",x"D7",x"92",x"AE",x"AB",
		x"60",x"A4",x"DD",x"6A",x"B8",x"8D",x"C3",x"95",x"F4",x"68",x"C5",x"3E",x"09",x"47",x"DC",x"A2",
		x"95",x"FA",x"26",x"49",x"4B",x"73",x"B2",x"EA",x"9D",x"54",x"F9",x"D1",x"46",x"B9",x"B9",x"55",
		x"95",x"D8",x"50",x"A5",x"6A",x"76",x"5D",x"EA",x"D2",x"14",x"71",x"C4",x"4D",x"59",x"52",x"DE",
		x"42",x"D5",x"A4",x"64",x"45",x"9B",x"3B",x"D7",x"DC",x"96",x"35",x"A5",x"EA",x"DC",x"F5",x"4A",
		x"DE",x"B4",x"8A",x"F1",x"36",x"0D",x"45",x"55",x"A6",x"42",x"33",x"D7",x"95",x"95",x"A6",x"88",
		x"D4",x"2C",x"06",x"6C",x"6A",x"C6",x"80",x"1F",x"3D",x"18",x"F0",x"7D",x"A7",x"71",x"A7",x"5C",
		x"27",x"8C",x"4C",x"46",x"1D",x"B1",x"33",x"34",x"C8",x"98",x"60",x"16",x"11",x"B2",x"4D",x"9C",
		x"D2",x"59",x"45",x"D0",x"2F",x"71",x"C9",x"BB",x"27",x"EA",x"18",x"B9",x"2D",x"9F",x"91",x"59",
		x"F5",x"64",x"B5",x"62",x"04",x"51",x"96",x"57",x"58",x"CA",x"EE",x"C5",x"58",x"4E",x"96",x"2B",
		x"A3",x"14",x"4F",x"5D",x"D5",x"A6",x"74",x"86",x"3B",x"BC",x"54",x"99",x"32",x"2A",x"2E",x"CD",
		x"88",x"19",x"B2",x"96",x"BC",x"49",x"AD",x"B5",x"30",x"4B",x"76",x"57",x"8F",x"A6",x"C8",x"AE",
		x"C1",x"C3",x"DD",x"E3",x"9A",x"24",x"0D",x"E1",x"35",x"5E",x"12",x"92",x"14",x"0B",x"66",x"A8",
		x"4E",x"4A",x"B2",x"1F",x"F0",x"95",x"D4",x"2D",x"4E",x"36",x"24",x"3B",x"12",x"8F",x"B8",x"4A",
		x"B1",x"8D",x"68",x"52",x"E2",x"8A",x"CD",x"2F",x"2C",x"AE",x"8B",x"13",x"C9",x"6A",x"71",x"BB",
		x"29",x"C9",x"34",x"32",x"DC",x"93",x"B4",x"AC",x"B2",x"50",x"8D",x"6A",x"D2",x"8A",x"61",x"94",
		x"DC",x"6A",x"4E",x"AA",x"47",x"66",x"12",x"B9",x"C6",x"A1",x"9D",x"5E",x"91",x"23",x"63",x"B1",
		x"69",x"5A",x"21",x"51",x"B7",x"2D",x"80",x"BD",x"A6",x"15",x"B0",x"E7",x"AD",x"02",x"D6",x"F8",
		x"6E",x"D1",x"EA",x"D7",x"19",x"22",x"B9",x"15",x"3D",x"3A",x"AA",x"65",x"E3",x"51",x"8E",x"CE",
		x"AA",x"B6",x"89",x"46",x"39",x"06",x"9B",x"F8",x"39",x"18",x"E5",x"E8",x"6C",x"92",x"6B",x"A3",
		x"15",x"A3",x"B0",x"49",x"B5",x"CD",x"92",x"F7",x"8C",x"2A",x"3D",x"32",x"42",x"9E",x"14",x"55",
		x"46",x"33",x"76",x"79",x"54",x"1C",x"E3",x"61",x"27",x"E5",x"4D",x"32",x"E6",x"96",x"95",x"54",
		x"36",x"4B",x"1C",x"E3",x"B5",x"53",x"95",x"8D",x"68",x"86",x"B5",x"76",x"8D",x"B7",x"E9",x"1D",
		x"9C",x"52",x"B5",x"36",x"85",x"37",x"F1",x"62",x"D3",x"85",x"E8",x"B6",x"CC",x"53",x"54",x"1F",
		x"B3",x"C8",x"19",x"DF",x"32",x"43",x"6E",x"AC",x"A7",x"3A",x"D9",x"8D",x"B9",x"B0",x"9C",x"C6",
		x"18",x"37",x"D6",x"2A",x"34",x"9A",x"63",x"DC",x"D8",x"06",x"AB",x"69",x"C7",x"0E",x"53",x"EF",
		x"A2",x"AC",x"53",x"DB",x"4D",x"BD",x"8B",x"A8",x"4E",x"AD",x"30",x"F5",x"A6",x"A2",x"52",x"B5",
		x"DD",x"D4",x"BC",x"9A",x"99",x"4F",x"55",x"73",x"35",x"6A",x"69",x"52",x"0B",x"2D",x"DD",x"29",
		x"89",x"98",x"6D",x"F6",x"77",x"EB",x"16",x"E1",x"72",x"CC",x"5D",x"BC",x"94",x"B9",x"38",x"71",
		x"75",x"96",x"98",x"6D",x"61",x"BB",x"34",x"45",x"AB",x"95",x"95",x"A5",x"D4",x"54",x"CB",x"19",
		x"5E",x"92",x"4B",x"DB",x"12",x"BB",x"E4",x"48",x"4A",x"4D",x"4F",x"64",x"52",x"2B",x"D3",x"35",
		x"CD",x"83",x"76",x"8D",x"28",x"D1",x"16",x"89",x"D6",x"D9",x"92",x"18",x"B0",x"EA",x"96",x"00",
		x"56",x"B9",x"60",x"C0",x"AE",x"1B",x"04",x"58",x"39",x"39",x"34",x"23",x"A1",x"EA",x"8C",x"28",
		x"D7",x"75",x"0B",x"E9",x"53",x"08",x"45",x"1F",x"24",x"75",x"7A",x"A2",x"52",x"43",x"10",x"12",
		x"E5",x"61",x"2B",x"F4",x"CB",x"85",x"A7",x"99",x"24",x"02",x"BC",x"A9",x"C9",x"80",x"9F",x"BD",
		x"18",x"F0",x"4B",x"A4",x"00",x"5E",x"C9",x"4C",x"79",x"A7",x"A6",x"6D",x"D9",x"B0",x"94",x"45",
		x"49",x"A5",x"6E",x"EC",x"50",x"65",x"AD",x"E5",x"36",x"B1",x"58",x"D7",x"A4",x"88",x"AB",x"39",
		x"36",x"6D",x"55",x"6A",x"6E",x"1E",x"C7",x"74",x"49",x"72",x"78",x"5B",x"4D",x"D3",x"27",x"49",
		x"11",x"95",x"A6",x"5C",x"5F",x"35",x"99",x"67",x"5B",x"32",x"43",x"53",x"60",x"DD",x"09",x"C7",
		x"8C",x"C3",x"21",x"7B",x"B5",x"64",x"37",x"F6",x"80",x"1C",x"D1",x"B2",x"D4",x"58",x"24",x"A5",
		x"6B",x"33",x"56",x"63",x"91",x"98",x"A9",x"A5",x"38",x"0C",x"D5",x"A9",x"3B",x"8F",x"E4",x"34",
		x"14",x"E3",x"69",x"56",x"B2",x"D3",x"50",x"6C",x"94",x"7A",x"C9",x"76",x"63",x"72",x"15",x"1A",
		x"AE",x"28",x"4C",x"C5",x"46",x"49",x"A4",x"15",x"B7",x"34",x"27",x"C5",x"15",x"91",x"CD",x"D6",
		x"B3",x"26",x"B5",x"97",x"71",x"DB",x"A8",x"92",x"94",x"19",x"D3",x"AD",x"3D",x"72",x"50",x"B7",
		x"43",x"31",x"77",x"4F",x"41",x"DE",x"0A",x"C9",x"98",x"35",x"87",x"EA",x"B2",x"24",x"7E",x"8B",
		x"11",x"0A",x"C9",x"99",x"D5",x"C3",x"95",x"1B",x"BB",x"1C",x"F6",x"0E",x"3F",x"6E",x"66",x"4E",
		x"FE",x"FF"
	);
	-- speak the word "eight"
--	type DATA_ARRAY is array (0 to 80) of std_logic_vector(7 downto 0);
--	signal DATA   : DATA_ARRAY := (
--		-- reset chip with a sequence of ten 0xFF writes
--		x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",x"FF",
--		-- "Speak External" command
--		x"60",
--		-- speech data follows
--		x"A9",x"28",x"5E",x"D4",x"AB",x"AB",x"8C",x"74",
--		x"38",x"13",x"C9",x"5A",x"33",x"92",x"11",x"5C",
--		x"D8",x"73",x"C9",x"48",x"BA",x"37",x"91",x"EC",
--		x"25",x"23",x"E9",x"4E",x"59",x"7A",x"E6",x"8C",
--		x"7C",x"18",x"16",x"9E",x"99",x"DD",x"9A",x"15",
--		x"4C",x"C0",x"67",x"4D",x"19",x"56",x"0A",x"05",
--		x"9A",x"D6",x"7A",x"00",x"00",x"06",x"4C",x"16",
--		x"8A",x"80",x"61",x"59",x"10",x"D0",x"8C",x"29",
--		x"02",x"B2",x"76",x"01",x"00",x"78"
--	);

	-- Clock period for 640KHz
	constant CLK_period : time := 1 ms / 640;
	constant intra : time := CLK_period*380;

begin
	uut: entity work.TMS5220 port map (
		I_OSC    => CLK,
		I_ENA    => '1',
		I_WSn    => I_WSn,
		I_RSn    => I_RSn,
		I_DATA   => I_DATA,
		I_TEST   => I_TEST,
		I_DBUS   => I_DBUS,
		O_DBUS   => O_DBUS,
		O_RDYn   => O_RDYn,
		O_INTn   => O_INTn,
		O_M0     => O_M0,
		O_M1     => O_M1,
		O_ADD8   => O_ADD8,
		O_ADD4   => O_ADD4,
		O_ADD2   => O_ADD2,
		O_ADD1   => O_ADD1,
		O_ROMCLK => O_ROMCLK,
		O_T11    => O_T11,
		O_IO     => O_IO,
		O_PRMOUT => O_PRMOUT,
		O_SPKR   => O_SPKR
	);

	-- Clock process definitions
	p_CLK : process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;

	-- Stimulus process - simple state machine
	stim_proc: process
	begin
		wait until rising_edge(CLK);
		case state is
			when 0 =>				-- init signal levels
				I_DATA <= '1';
				I_TEST <= '1';
				count  <= 0;
				index  <= 0;
				state  <= state + 1;

				I_WSn  <= '0';		-- chip reset condition
				I_RSn  <= '0';
			when 1 =>
				I_WSn  <= '1';		-- release reset
				I_RSn  <= '1';
				state <= state + 1;

			-- read status
			when 2 =>				-- assert RSn
				I_RSn <= '0';
				state <= state + 1;
			when 3 =>
				I_RSn <= '1';
				state <= state + 1;
			when 4 =>				-- if status Buffer Low=1, advance state, else loop back
				if O_DBUS(6) = '1' then
					state <= state + 1;
				else
					state <= 2;
				end if;

			-- write data
			when 5 =>				-- assert WSn with new data byte
				I_WSn <= '0';
				I_DBUS <= DATA(count);
				count <= count + 1;
				state <= state + 1;
			when 6 =>				-- if more bytes, loop back
				I_WSn <= '1';
				if count <= datalen then
					state <= 1;
				else
					state <= state + 1;
				end if;

			when others => null;	-- end state
		end case;
	end process;
end;
