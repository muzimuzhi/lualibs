-- Build script for lualibs
packageversion="2.66"
packagedate="2019-07-04"


local ok, mydata = pcall(require, "ulrikefischerdata.lua")
if not ok then
  mydata= {email="XXX",github="XXX",name="XXX"}
end

print(mydata.email)

module   = "lualibs"
ctanpkg  = "lualibs"

uploadconfig = {
  pkg     = ctanpkg,
  version = "v"..packageversion.." "..packagedate,
  author  = "Philipp Gesang; Élie Roux",
  license = "gpl2",
  summary = "Additional Lua functions for LuaTeX macro programmers",
  ctanPath = "/macros/luatex/generic/lualibs",
  repository = mydata.github .. "lualibs",
  bugtracker = mydata.github .. "lualibs/issues",
  support    = mydata.github .. "lualibs/issues",
  uploader   = mydata.name,
  email      = mydata.email, 
  update   = true ,
  topic=    {"luatex","lua-supp"},
  note     = [[Uploaded automatically by l3build... Description and authors unchanged]],
  description=[[Lualibs is a collection of Lua modules useful for general programming. 
  The bundle is based on lua modules shipped with ConTeXt, and made available in this bundle for use independent of ConTeXt.]],
  announcement="This version syncs the files with the ConTeXt files from "..packagedate.."."              
}

checkengines = {"luatex"}
checkruns    = 3
packtdszip   =true

-- documentation

typesetexe   = "lualatex"
unpackfiles  =  {"*.dtx"}
docfiles     = {"README","NEWS","LICENSE"}

-- automatic tagging: perhaps later ...

installfiles = {
                "**/lualibs-*.lua",
                "lualibs.lua",
               }  

-- ctan setup
tdsroot = "luatex"
textfiles    = {"README","NEWS","LICENSE"}

               
sourcefiles  = {
                "*.dtx",
                "lualibs-*.lua",
               }



-- set texmfhome for local installation.
-- the files go to the side-by-side folder of luaotfload
-- to make it easier to run the tests there.          
options["texmfhome"] = "../luaotfload/texmf"              



kpse.set_program_name ("kpsewhich")
if not release_date then
 dofile ( kpse.lookup ("l3build.lua"))
end
