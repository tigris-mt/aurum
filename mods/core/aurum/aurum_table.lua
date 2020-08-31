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
	VERSION = "0.54.0.0",
	-- Expected Minetest Engine version (>=).
	MT_VERSION = "5.3.0",
}
