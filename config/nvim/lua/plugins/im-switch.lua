return {
    "Kicamon/im-switch.nvim",
    event = "InsertEnter", 
    opts = {
        input_toggle = 1,
        text = {
                enable = true,
                files = { "*.md", "*.txt" },
        },
        code = {
                enable = true,
                files = { "*" },
        },
        en = "fcitx5-remote -c",
        zh = "fcitx5-remote -o",
        check = "fcitx5-remote",
    },
}
