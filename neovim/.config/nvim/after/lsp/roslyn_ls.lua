-- Microsoft's Roslyn language server (the one behind VS Code's C# Dev Kit).
--
-- Unity: the server needs the .sln/.csproj files Unity generates. Install the
-- "Visual Studio Editor" package (com.unity.ide.visualstudio), then use
-- Preferences > External Tools > "Regenerate project files".
return {
  settings = {
    ["csharp|background_analysis"] = {
      -- Unity solutions are large; only analyze what's open.
      dotnet_analyzer_diagnostics_scope = "openFiles",
      dotnet_compiler_diagnostics_scope = "openFiles",
    },
    ["csharp|completion"] = {
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
    ["csharp|inlay_hints"] = { -- toggle with <leader>uh
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_parameters = true,
    },
    ["csharp|symbol_search"] = {
      dotnet_search_reference_assemblies = true,
    },
  },
}
