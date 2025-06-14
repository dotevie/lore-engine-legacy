package;

import haxe.Constraints.Function;
import Sys.sleep;
import discord_rpc.DiscordRpc;

#if LUA_ALLOWED
import llua.Lua;
import llua.State;
using llua.Lua.Lua_helper;
#end
import lore.macros.MacroTools;

using StringTools;

class DiscordClient
{
	public static var isInitialized:Bool = false;
	public static final defaultClientID:String = MacroTools.getDiscordClientID();
	private static var __curID:String = defaultClientID;
	public function new()
	{
		trace("Discord Client starting...");
		DiscordRpc.start({
			clientID: defaultClientID,
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");

		while (true)
		{
			DiscordRpc.process();
			sleep(2);
			//trace("Discord Client Update");
		}

		DiscordRpc.shutdown();
	}
	
	public static function shutdown()
	{
		DiscordRpc.shutdown();
	}
	
	static function onReady()
	{
		DiscordRpc.presence({
			details: "In the Menus",
			state: null,
			largeImageKey: 'icon',
			largeImageText: "Engine Version: v" + MainMenuState.loreEngineVersion
		});
	}

	static function onError(_code:Int, _message:String)
	{
		trace('Error! $_code : $_message');
	}

	static function onDisconnected(_code:Int, _message:String)
	{
		trace('Disconnected! $_code : $_message');
	}

	public static function initialize()
	{
		var DiscordDaemon = sys.thread.Thread.create(() ->
		{
			new DiscordClient();
		});
		trace("Discord Client initialized");
		isInitialized = true;
	}

	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float)
	{
		var startTimestamp:Float = if(hasStartTimestamp) Date.now().getTime() else 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'icon',
			largeImageText: "Engine Version: v" + MainMenuState.loreEngineVersion,
			smallImageKey : smallImageKey,
			// Obtained times are in milliseconds so they are divided so Discord can use it
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});

		//trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State) {
		lua.add_callback("changePresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});
		lua.add_callback("changeDiscordClientID", changeClientID);
	}
	#end
	public static function changeClientID(?id:Null<String>) {
		if (__curID == id || (__curID == defaultClientID && id == null)) return;
		DiscordRpc.shutdown();
		DiscordRpc.start({
			clientID: id ?? defaultClientID,
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		__curID = id ?? defaultClientID;
	}
}
