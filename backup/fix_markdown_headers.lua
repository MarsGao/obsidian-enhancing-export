function Para(el)
  -- Reset function for each paragraph
  local first = el.content[1]
  
  -- Check if the paragraph starts with standard Str containing only '#'
  if first and first.t == 'Str' and string.match(first.text, "^#+$") then
    local level = string.len(first.text)
    
    -- Limit to valid header levels 1-6
    if level >= 1 and level <= 6 then
      local second = el.content[2]
      
      -- Must be followed by a Space to be considered a valid ATX Header style (loosely)
      if second and second.t == 'Space' then
        -- Remove the marker ("###") and the following Space
        table.remove(el.content, 1)
        table.remove(el.content, 1)
        
        -- Return as a Header element
        return pandoc.Header(level, el.content)
      end
    end
  end
  return el
end
