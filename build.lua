-- Build script for lualibs
packageversion="2.6"
packagedate="2018/09/21"

module   = "lualibs"
ctanpkg  = "lualibs"

checkengines = {"luatex"}
checkruns    = 3

-- automatic tagging: perhaps later ...

-- ctan setup
tdsroot = "luatex"

textfiles    = {"README","NEWS","LICENSE"}
docfiles     = {"README","NEWS","LICENSE"}

installfiles = {
                "*.lua"
               }  
               
sourcefiles  = {
                "*.dtx",
                "whatsnew.lua",
                "Makefile",
                "test-lualibs.lua"
               }

unpackfiles =  {"*.dtx"}
                            


kpse.set_program_name ("kpsewhich")
if not release_date then
 dofile ( kpse.lookup ("l3build.lua"))
end
