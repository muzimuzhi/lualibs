-- Build script for lualibs
packageversion="2.6"
packagedate="2018/09/21"

module   = "lualibs"
ctanpkg  = "lualibs"

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
