if not pcall(require, "love.filesystem") then
	error("love.filesystem is required")
end
local lfs = require "love.lfs"
print(lfs._VERSION)

print("loading lfs-find...")
local find = require "lfs-find"
find.lfs = lfs -- use love.lfs

print("loading testcode...")
require"testcode"(find, ".")
