#!/usr/bin/env texlua
--[===[--

    import-from-context.lua -- copy renamed copies from the context installation.
                    Part of the Lualibs package.
                    https://github.com/u-fischer/lualibs
    made by adapting the existing whatsnew script.
    
    !!!!!!!!!!!!!!!
     needs a CONTEXTPATH environment variable that points to tex\texmf-context 
    !!!!!!!!!!!!!!!               

    Copyright 2013, 2018 Philipp Gesang, Ulrike Fischer
    License: GPL v2.0

--]===]--

-- for the import function, to get file.copy working:
kpse.set_program_name "luatex"
require "lualibs"

-----------------------------------------------------------------------
---                          configuration
-----------------------------------------------------------------------

local prefixsep     = "-"
local namespace     = "lualibs"
local luasuffix     = ".lua"
local contextpath   = os.env["CONTEXTPATH"] or ("/home/phg/context/tex/texmf-context") -- UF changed
local basedir       = contextpath .. "/tex/context/base/mkiv"                          -- UF 20.09.2018
print(basedir)
local cmd_diff      = [[diff "%s" "%s"]]

-----------------------------------------------------------------------
---                             locals
-----------------------------------------------------------------------

local iopopen       = io.popen
local stringexplode = string.explode
local stringformat  = string.format
local stringsub     = string.sub
local tableunpack   = table.unpack

-----------------------------------------------------------------------
---                              files
-----------------------------------------------------------------------

--- (prefix, keep) hash_t
local namespaces = { { "l"    , false },
                     { "util" , true  },
                     { "trac" , true  }, }

--- (prefix, name list) hash_t
local filenames = {
  ["l"] = {
    "boolean",
    "dir",
    "file",
    "function",
    "io",
    "lpeg",
    "lua",
    "math",
    "md5",
    "number",
    "os",
    "package",
    "set",
    "string",
    "table",
    "unicode",
    "url",
  },

  ["trac"] = { "inf" },

  ["util"] = {
    "deb",
    "dim",
    "jsn",
    "lua",
    "prs",
    "sac",
    "sta",
    "sto",
    "str",
    "tab",
    "tpl",
    "zip",
  },
}

-----------------------------------------------------------------------
---                             helpers
-----------------------------------------------------------------------

--- string -> string -> bool -> (string, string)
local mknames = function (pfx, name, keeppfx)
  local libname = basedir .. "/" .. pfx
               .. prefixsep .. name .. luasuffix
  local ourname = prefixsep .. name .. luasuffix
  if keeppfx == true then
    ourname = prefixsep .. pfx .. ourname
  end
  ourname = namespace .. ourname
  ourname = "./" .. ourname
  return ourname, libname
end

--- string -> (int * int)
local count_changes = function (str)
  local added, removed = 0, 0
  for n, line in next, stringexplode(str, "\n") do
    local first = stringsub(line, 1, 1)
    if first == "<" then
      removed = removed + 1
    elseif first == ">" then
      added = added + 1
    end
  end
  return added, removed
end

--- string -> string -> (int * int)
local run_diff = function (f1, f2)
  local cmd = stringformat(cmd_diff, f1, f2)
  local res = iopopen(cmd, "r")
  local dat = res:read"*all"
  res:close()
  return count_changes(dat)
end

-----------------------------------------------------------------------
---                              main
-----------------------------------------------------------------------

local libs_done     = 0
local total_added   = 0
local total_removed = 0

for n, namespace in next, namespaces do
  local pfx, keeppfx = tableunpack(namespace)
  local libs = filenames[pfx]
  for i=1, #libs do
    libs_done = libs_done + 1
    local current = libs[i]
    local from, to = mknames(pfx, current, keeppfx)
    if lfs.isfile(from) and lfs.isfile(to) then
      local added, removed = run_diff (from, to)
      if added > 0 or removed > 0 then
        total_added   = total_added + added
        total_removed = total_removed + removed
        print(stringformat(
          "(library %q (plus %d) (minus %d))",
          from, added, removed
        ))
 file.copy (to, from)                -- added UF
 print("copy from ", to,"to ",from)  -- debug
      end
    else
      if not lfs.isfile(from) then
        print("cannot read file", from)
      elseif not lfs.isfile(to) then
        print("cannot read file", to)
      end
      goto fail
    end
  end
end

::done::
if total_added == 0 and total_removed == 0 then
  print "stagnation"
else
  print(stringformat(
    "(progress (n-files %d) (added %d) (removed %d))",
    libs_done, total_added, total_removed
  ))
end
os.exit(0)

::fail::
print "fatal error"
os.exit(1)

