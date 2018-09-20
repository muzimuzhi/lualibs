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



-- set texmfhome for local installation in the git          
-- os.setenv("TEXMFHOME","C:\\Users\\Nililand-Surface\\Documents\\Git\\luaotfload\\texmf")                  
os.setenv("TEXMFHOME",lfs.currentdir().."/../luaotfload/texmf")                  


kpse.set_program_name ("kpsewhich")
if not release_date then
 dofile ( kpse.lookup ("l3build.lua"))
end
