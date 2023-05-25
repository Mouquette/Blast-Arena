local EventManager = {}

local events = {}

function EventManager.addEventListener(event, callback)
  if not events[event] then
    events[event] = {}
  end

  table.insert(events[event], callback)
end

function EventManager.removeEventListener(event, callback)
  if not events[event] then
    return
  end

  for k, v in ipairs(events[event]) do
    if v == callback then
      table.remove(events[event], k)
      break
    end
  end
end

function EventManager.dispatch(event, ...)
  if not events[event] then
    return
  end

  for k, callback in ipairs(events[event]) do
    callback(...)
  end
end

return EventManager
