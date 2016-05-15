local computers = {}
local configPath = "computers"
local modemSide = "left"

function loadConfig()
  if fs.exists(configPath)  then
    if fs.getSize(configPath) ~= 0 then
      for line in io.lines(configPath) do
        computers[line] = true
      end
      return true
    else
      print("Computer list empty")
    end
  else
    print("Couldn't find computer list, generating empty file \""..configPath.."\"")
    f = fs.open(configPath, "w")
    f.flush()
    f.close()
  end
  return false
end

function startComputers()
  m = peripheral.wrap(modemSide)

  for id, _ in pairs(computers) do
    m.callRemote("computer_"..id, "turnOn")
  end
end

if shell.getRunningProgram() == "usr/bin/wakeonlan" then
  configPath = "etc/wakeonlan"
end

if loadConfig() then
  startComputers()
end

print(textutils.serialize(computers))
