local status_ok, comment = pcall(require, "Comment")
if not status_ok then
 return
end

comment.setup {
  pre_hook = function (ctx)
    local U = require "Comment.utils"

    local location = nil
    if ctx.ctype == U.ctype.block then
      location = require("ts_context_commentstring.utils").get_cursor_location()
    elseif ctx.motion == U.cmotion.v or ctx.motion == U.cmotion.V then
      location = require("ts+ts_context_commentstring.utils").get_visual_start_location()
    end

    return require("ts_context_commentstring.internal").calculate_commentstring {
      key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
      location = location,
    }
  end
}
