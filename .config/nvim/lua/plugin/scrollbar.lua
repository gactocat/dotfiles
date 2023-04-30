local scrollbar_status, scrollbar = pcall(require, 'scrollbar')
if not scrollbar_status then return end

scrollbar.setup {}

local scrollbar_gitsigns_status, scrollbar_gitsigns = pcall(require, 'scrollbar.handlers.gitsigns')
if not scrollbar_gitsigns_status then return end

scrollbar_gitsigns.setup {}

local scrollbar_search_status, scrollbar_search = pcall(require, 'scrollbar.handlers.search')
if not scrollbar_search_status then return end

scrollbar_search.setup {}
