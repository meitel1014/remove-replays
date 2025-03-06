obs         = obslua
source_name = ""
hotkey_id   = obs.OBS_INVALID_HOTKEY_ID
attempts    = 0

----------------------------------------------------------

function remove_replays(pressed)
	if not pressed then
		return
	end
	local source = obs.obs_get_source_by_name(source_name)
	source_id = obs.obs_source_get_id(source)
	if source_id ~= "vlc_source" then
		return
	elseif source ~= nil then
		local settings = obs.obs_data_create()
		-- "playlist"
		array = obs.obs_data_array_create()
		obs.obs_data_set_array(settings, "playlist", array)

		-- updating will automatically cause the source to
		-- refresh if the source is currently active
		obs.obs_source_update(source, settings)
		obs.obs_data_array_release(array)

		obs.obs_data_release(settings)
		obs.obs_source_release(source)
	end
end


----------------------------------------------------------

-- A function named script_update will be called when settings are changed
function script_update(settings)
	source_name = obs.obs_data_get_string(settings, "source")
end

-- A function named script_description returns the description shown to
-- the user
function script_description()
	return "VLCビデオソースのプレイリストを一括削除します"
end

-- A function named script_properties defines the properties that the user
-- can change for the entire script module itself
function script_properties()
	props = obs.obs_properties_create()

	local p = obs.obs_properties_add_list(props, "source", "Media Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
	local sources = obs.obs_enum_sources()
	if sources ~= nil then
		for _, source in ipairs(sources) do
			source_id = obs.obs_source_get_id(source)
			if source_id == "vlc_source" then
				local name = obs.obs_source_get_name(source)
				obs.obs_property_list_add_string(p, name, name)
			else
				-- obs.script_log(obs.LOG_INFO, source_id)
			end
		end
	end
	obs.source_list_release(sources)

	return props
end

-- A function named script_load will be called on startup
function script_load(settings)
	hotkey_id = obs.obs_hotkey_register_frontend("remove_replays.trigger", "リプレイを削除", remove_replays)
	local hotkey_save_array = obs.obs_data_get_array(settings, "remove_replays.trigger")
	obs.obs_hotkey_load(hotkey_id, hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)
end

-- A function named script_save will be called when the script is saved
--
-- NOTE: This function is usually used for saving extra data (such as in this
-- case, a hotkey's save data).  Settings set via the properties are saved
-- automatically.
function script_save(settings)
	local hotkey_save_array = obs.obs_hotkey_save(hotkey_id)
	obs.obs_data_set_array(settings, "remove_replays.trigger", hotkey_save_array)
	obs.obs_data_array_release(hotkey_save_array)
end
