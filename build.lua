-- Build script for lualibs
packageversion= "2.67"
packagedate= "2019-08-11"

module   = "lualibs"
ctanpkg  = "lualibs"

-- get personal data
local ok, mydata = pcall(require, "ulrikefischerdata.lua")
if not ok then
  mydata= {email="XXX",github="XXX",name="XXX"}
end

print(mydata.email)

uploadconfig = {
  pkg        = ctanpkg,
  version    = "v"..packageversion.." "..packagedate,
  author     = "Philipp Gesang; Élie Roux",
  license    = "gpl2",
  summary    = "Additional Lua functions for LuaTeX macro programmers",
  ctanPath   = "/macros/luatex/generic/lualibs",
  repository = mydata.github .. "lualibs",
  bugtracker = mydata.github .. "lualibs/issues",
  support    = mydata.github .. "lualibs/issues",
  uploader   = mydata.name,
  email      = mydata.email, 
  update     = true ,
  topic      = {"luatex","lua-supp"},
  note       = [[Uploaded automatically by l3build... Description and authors unchanged]],
  description=[[Lualibs is a collection of Lua modules useful for general programming. 
  The bundle is based on lua modules shipped with ConTeXt, and made available in this bundle for use independent of ConTeXt.]],
  announcement="This version syncs the files with the ConTeXt files from "..packagedate.."."              
}

-- check (currently no tests)
stdengine    = "luatex"
checkengines = {"luatex"}
checkruns    = 3

---------------------------------------------
-- l3build settings for CTAN/install target
---------------------------------------------

packtdszip   =true
-- sourcefiledir (default .)
-- docfiledir    (default .)

-- set texmfhome for local installation.
-- the files go to the side-by-side folder of luaotfload
-- to make it easier to run the tests there and to have a complete
-- set there for users
          
options["texmfhome"] = "../luaotfload/texmf"           
ctanreadme= "CTANREADME.md"
-------------------
-- documentation
-------------------

typesetexe   = "lualatex"
unpackfiles  = {"*.dtx"}

textfiles = 
 {
  "LICENSE",
  "NEWS",
  "CTANREADME.md",
 }

---------------------
-- installation
---------------------
tdsroot = "luatex"

installfiles = {
                "**/lualibs-*.lua",
                "lualibs.lua",
               }  

sourcefiles  = {
                "*.dtx",
                "lualibs-*.lua",
               }

-----------------------------
-- l3build settings for tags:
-----------------------------
tagfiles = {
            "CTANREADME.md",
            "README.md",
            "lualibs.dtx",
            }

function update_tag (file,content,tagname,tagdate)
 tagdate = string.gsub (packagedate,"-", "/")
 if string.match (file, "%.dtx$" ) then
  content = string.gsub (content,  
                         "%d%d%d%d/%d%d/%d%d [a-z]+%d%.%d+",
                         tagdate.." v"..packageversion)
  content = string.gsub (content,  
                         "%d%d%d%d%-%d%d%-%d%d [a-z]+%d%.%d+",
                         packagedate.." v"..packageversion)
  content = string.gsub (content,  
                         '(version%s*=%s*")%d%.%d+(",%s*--TAGVERSION)',
                         "%1"..packageversion.."%2")
  content = string.gsub (content,  
                         '(date%s*=%s*")%d%d%d%d%-%d%d%-%d%d(",%s*--TAGDATE)',
                         "%1"..packagedate.."%2")                                                  
  return content                         
 elseif string.match (file, "^README.md$") then
   content = string.gsub (content,  
                         "Version: %d%.%d+",
                         "Version: " .. packageversion )
   content = string.gsub (content,  
                         "version%-%d%.%d+",
                         "version-" .. packageversion ) 
   content = string.gsub (content,  
                         "for %d%.%d+",
                         "for " .. packageversion ) 
   content = string.gsub (content,  
                         "%d%d%d%d%-%d%d%-%d%d",
                         packagedate )
   local imgpackagedate = string.gsub (packagedate,"%-","--")                          
   content = string.gsub (content,  
                         "%d%d%d%d%-%-%d%d%-%-%d%d",
                         imgpackagedate)                                                                                                     
   return content
 elseif string.match (file, "CTANREADME.md$") then
   content = string.gsub (content,  
                         "VERSION: %d%.%d+",
                         "VERSION: " .. packageversion )
   content = string.gsub (content,  
                         "DATE: %d%d%d%d%-%d%d%-%d%d",
                         "DATE: " .. packagedate )                                                                          
   return content                               
 end
 return content
 end   



kpse.set_program_name ("kpsewhich")
if not release_date then
 dofile ( kpse.lookup ("l3build.lua"))
end
