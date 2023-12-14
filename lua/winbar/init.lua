local config = require('winbar.config')

local M = {}

function M.run_on_current_buffer()
    local winbar = require("winbar.winbar")

    if vim.bo.filetype ~= "qf" then
        winbar.show_winbar()

        return
    end

    local exists_devicons, devicons = pcall(require, "nvim-web-devicons")
    local icon = ""

    if exists_devicons then
        icon = devicons.get_icon("", "vim", { default = default })
    end

    list = vim.fn.getloclist(0, {title=true, winid=true})

    if list.winid ~= 0 then
        winbar.show_winbar(
            " %#DevIconvim#" .. icon .. " " .. list.title .. "%*%#String %*"
        )

        return
    end

    local list = vim.fn.getqflist({title=true, winid=true})

    if list.winid ~= 0 then
        winbar.show_winbar(
            " %#DevIconvim#" .. icon .. " " .. list.title .. "%*%#String %*"
        )

        return
    end
end


function M.setup(opts)
    config.set_options(opts)

    local winbar = require("winbar.winbar")

    winbar.init()

    if opts.enabled == true then
        vim.api.nvim_create_autocmd(
            {
                "BufFilePost",
                "BufWinEnter",
                "BufWritePost",
                "CursorMoved",
                "DirChanged",
                "InsertEnter",
            },
            { callback = M.run_on_current_buffer }
        )
    end
end

return M
