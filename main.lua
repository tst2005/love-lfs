print(_VERSION)
local love_VERSION
local maj, min, rev
if love._version_major and love._version_minor and love._version_revision then
	maj, min, rev = love._version_major, love._version_minor, love._version_revision
elseif love.getVersion then
	maj, min, rev = love.getVersion()
end
print( string.format("love %s.%s.%s", maj or "?", min or "?", rev or "?") )


dofile("sample.lua")


if love.event.quit then
	print("use love.event.quit()")
        love.event.quit()
elseif love.event.push then
	print("use love.event.push('quit')")
        love.event.push('quit')
else
	print("use os.exit(0)")
        os.exit(0)
end
