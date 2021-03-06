-- This file must not reference any other file.
-- It can be read by external lua interpreters.

-- Create the aurum table and populate it with metadata.
aurum = {
	-- Current version number.
	-- MAJOR.ITERATION.MINOR.PATCH
	--- MAJOR is incremented for incompatible changes.
	--- ITERATION is incremented for milestone releases.
	--- MINOR is incremented for new features.
	--- PATCH is incremented for minor changes and bugfixes.
	VERSION = "0.60.1.0",

	-- Expected Minetest Engine version (>=).
	MT_VERSION = "5.4.0",

	-- Base screenshot image; relative to screenshots/ directory.
	SCREENSHOT = "aurum_graveyard.0.23.2.png",
}
