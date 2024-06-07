namespace CWCore.Match.Scripts;

/// <summary>
/// Marks the method as a Lua function
/// </summary>
[AttributeUsage(AttributeTargets.Method)]
internal class LuaCommand : Attribute {}