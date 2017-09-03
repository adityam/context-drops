if not modules then modules = { } end modules ['test'] = {
    version   = 1.000,
    comment   = "overlay example",
    author    = "Peter Rolf",
    copyright = "Peter Rolf",
    email     = "peter.rolf@arcor.de",
    license   = "GNU General Public License"
}

thirddata         = thirddata         or { }
thirddata.ovltest = thirddata.ovltest or { }

local metafun = context.metafun
local test = thirddata.ovltest -- our namespace
local numberofpixels = thirddata.drops.numberofpixels
local getcurrent = thirddata.drops.getcurrent

local format,todimen = string.format, string.todimen
local tobasepoints = number.tobasepoints


-- generate the mppath id
function test.getpathID(width,height)
    print(format("debug: getpathID(): width=%s, height=%s",width,height))
    tex.pdfpxdimen = todimen("1in")/getcurrent("resolution") -- needed
    -- we need pixel as base dimension for the ID, as rounding 'bp' is not accurate enough with higher ppi values
    local w,h  = numberofpixels(width), numberofpixels(height)
    local name = format("ovltest:w%dh%d",w,h)
    print(format("debug: getpathID(): id=%s",name))
    return name
end


-- If nothing is drawn, we have to set the bounding box manually; otherwise the graphic is canceled.
function test.generatepath(id,width,height)
    print(format("debug: generatepath(): id=%s, width=%s,height=%s",id,width,height))
    if not metapost.variables[id] then
        local w,h
        -- metapost draws in bp units
        w = tobasepoints(width); h = tobasepoints(height)
        metafun.start()
        metafun("save p,pid; path p; string pid;")
        metafun("pid := \"%s\";",id)
        metafun("show pid;") -- needs '\ctxlua{metapost.showlog = true}'
        metafun("p:= unitcircle xyscaled(%s,%s);",w,h)
        metafun("passvariable(pid,p);")
        metafun("setbounds currentpicture to boundingbox p;")
        metafun.stop()
    end
end
