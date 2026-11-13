-- rust-analyzer (installed through mason). cargo, rustfmt and clippy come
-- from the rustup toolchain: `rustup component add clippy rustfmt`.
return {
  settings = {
    ["rust-analyzer"] = {
      -- Run clippy instead of `cargo check` for on-save diagnostics.
      check = { command = "clippy" },
    },
  },
}
