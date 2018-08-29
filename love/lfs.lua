local love = {
	filesystem = require "love.filesystem"
}

-- love.filesystem.areSymlinksEnabled
-- love.filesystem.setSymlinksEnabled
-- love.filesystem.isSymlink
-- love.filesystem.getRealDirectory

local lfs = {}

-- [x] lfs.attributes (filepath [, request_name | result_table])
--love.filesystem.getSize ; love.filesystem.getLastModified
local _info = love.filesystem.getInfo
if not _info then
	local isd, isf, isl = love.filesystem.isDirectory, love.filesystem.isFile, love.filesystem.isSymlink
	function _gettype(path)
		if isl and isl(path) then return "link" end
		if isd(path) then
			return "directory"
		elseif isf(path) then
			return "file"
		else
			return "other"
		end
	end
	_info = function(path, _not_implemented)
		assert(not _not_implemented)
		return {
			type = _gettype(path),
			size = nil,
			modtime = love.filesystem.getLastModified and love.filesystem.getLastModified(path),
		}
	end
end

function lfs.attributes(path, request_name_or_result_table)
	local loveinfos = _info(path)
	if type(request_name_or_result_table) == "string" then
		local lfs2love = {
			mode = "type",
			size = "size",
			modtime = "modification",
		}
		return loveinfos[lfs2love[request_name_or_result_table] or request_name_or_result_table] or nil
	end
	local r
	if request_name_or_result_table==nil then
		local filetype = loveinfos.type
		if filetype == "symlink" then
			filetype = "link"
		elseif filetype ~= "file" and filetype ~= "directory" then
			filetype = "other"
		end
		r = {
			dev = nil,
			ino = nil,
			-- LFS : file, directory, link, socket, named pipe, char device, block device or other
			-- LOVE: file, directory, symlink or other
			mode = filetype,

			nlink = nil,
			uid = 0,
			gid = 0,
			rdev = nil,
			acccess = nil,
			modification = loveinfos.modtime,
			change = loveinfos.modtime,
			size = loveinfos.size,
			permissions = nil,
			blocks = nil,
			blksize = nil,
		}
	else
		--r = request_name_or_result_table
		error("love.lfs.attributes: result_table not-implemented-yet")
	end
	return r
end

-- [ ] lfs.chdir(path)
-- [ ] lfs.lock_dir(path, [seconds_stale])

-- [x] lfs.currentdir ()
local pwd = love.filesystem.getWorkingDirectory
function lfs.currentdir()
	return pwd()
end

-- [x] iter, dir_obj = lfs.dir (path)
local ls = love.filesystem.getDirectoryItems or love.filesystem.enumerate
local function fs_iter(udata)
	local n = udata.n or 1
	local v = udata[n]
	if v ~= nil then
		udata.n = n+1
	end
	return v
end
function lfs.dir(path)
	return fs_iter, ls(path)
end

-- [ ] lfs.lock (filehandle, mode[, start[, length]])
-- [ ] lfs.link (old, new[, symlink])

-- [x] lfs.mkdir (dirname)
local mkdir = love.filesystem.createDirectory or love.filesystem.mkdir
function lfs.mkdir(dirname)
	return mkdir(dirname)
end

-- [x] lfs.rmdir (dirname)
local rm = love.filesystem.remove -- remove file or directory
local isd = love.filesystem.isDirectory
local isl = love.filesystem.isSymlink
function lfs.rmdir(dirname)
	if isd(path) and not isl(path) then
		return rm(path)
	end
	return false
end

-- [ ] lfs.setmode (file, mode)
-- [?] lfs.symlinkattributes (filepath [, aname])
lfs.symlinkattributes = lfs.attributes

-- [?] lfs.touch (filepath [, atime [, mtime]])
--local open = love.filesystem.newFile("data.txt")


-- [ ] lfs.unlock (filehandle[, start[, length]])

lfs._VERSION = "love.lfs 0.1.0"
return lfs
