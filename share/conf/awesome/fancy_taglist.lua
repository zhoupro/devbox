-- awesomewm fancy_taglist: a taglist that contains a tasklist for each tag.

-- Usage:
-- 1. Save as "fancy_taglist.lua" in ~/.config/awesome
-- 2. Add a fancy_taglist for every screen:
--          awful.screen.connect_for_each_screen(function(s)
--              ...
--              local fancy_taglist = require("fancy_taglist")
--              s.mytaglist = fancy_taglist.new({
--                  screen = s,
--                  taglist_buttons = mytagbuttons,
--                  tasklist_buttons = mytasklistbuttons
--              })
--              ...
--          end)
-- 3. Add s.mytaglist to your wibar.

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local module = {}

local generate_filter = function(t)
	return function(c, scr)
		local ctags = c:tags()
		for _, v in ipairs(ctags) do
			if v == t then
				return true
			end
		end
		return false
	end
end

local fancytasklist = function(cfg, t)
	return awful.widget.tasklist({
		screen = cfg.screen or awful.screen.focused(),
		filter = generate_filter(t),
		buttons = cfg.tasklist_buttons,
		widget_template = {
			{
				id = "clienticon",
				widget = awful.widget.clienticon,
			},

			margins = 2,
			widget = wibox.container.margin,
			create_callback = function(self, c, _, _)
				self:get_children_by_id("clienticon")[1].client = c
				awful.tooltip({
					objects = { self },
					timer_function = function()
						return c.name
					end,
				})
			end,
		},
	})
end

function module.new(config)
	local cfg = config or {}

	local s = cfg.screen or awful.screen.focused()
	local taglist_buttons = cfg.taglist_buttons

	return awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		widget_template = {
			{
				{
					-- tag
					{
						id = "text_role",
						widget = wibox.widget.textbox,

       					},
					-- tasklist
					{
						id = "tasklist_placeholder",
						layout = wibox.layout.fixed.horizontal,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
			layout = wibox.layout.fixed.horizontal,
			create_callback = function(self, _, index, _)
				local t = s.tags[index]
				self:get_children_by_id("tasklist_placeholder")[1]:add(fancytasklist(cfg, t))
			end,
		},
		buttons = taglist_buttons,
	})
end

return module
