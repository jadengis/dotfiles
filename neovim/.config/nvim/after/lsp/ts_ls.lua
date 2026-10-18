return {
  -- Only attach inside a project (tsconfig/jsconfig/package.json), never to loose files.
  workspace_required = true,
  init_options = {
    -- tsserver's Node heap limit in MB (--max-old-space-size). Node's default
    -- limit runs out in large monorepos and tsserver crashes.
    maxTsServerMemory = 16384,
  },
}
