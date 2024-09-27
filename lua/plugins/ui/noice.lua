-- Nicer notifications and command line UI.
return {
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = 'MunifTanjim/nui.nvim',
        opts = function()
          vim.cmd([[
            highlight NoiceCmdlinePopupBorder guifg=#ff0000
            highlight NoiceCmdline guifg=#ffffff guibg=#000000
          ]])
          return {
            no_highlights = true,
            presets = {
                -- Have borders around hover and signature help.
                lsp_doc_border = true,
                command_palette = true,
                long_message_to_split = true,
            },
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
                signature = {
                    auto_open = { enabled = false },
                },
            },
            status = {
                -- Statusline component for LSP progress notifications.
                lsp_progress = { event = 'lsp', kind = 'progress' },
            },
            routes = {
                -- Ignore the typical vim change messages.
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = '%d+L, %d+B' },
                            { find = '; after #%d+' },
                            { find = '; before #%d+' },
                            { find = '%d fewer lines' },
                            { find = '%d more lines' },
                        },
                    },
                    opts = { skip = true },
                },
                -- Don't show these in the default view.
                {
                    filter = {
                        event = 'lsp',
                        kind = 'progress',
                    },
                    opts = { skip = true },
                },
            },
        }
        end,
        keys = {
            { '<leader>fn', ':NoiceTelescope<cr>', desc = 'Noice' },
            {
                '<C-f>',
                function()
                    if not require('noice.lsp').scroll(4) then
                        return '<C-f>'
                    end
                end,
                silent = true,
                expr = true,
                desc = 'Scroll forward',
                mode = { 'i', 'n', 's' },
            },
            {
                '<C-b>',
                function()
                    if not require('noice.lsp').scroll(-4) then
                        return '<C-b>'
                    end
                end,
                silent = true,
                expr = true,
                desc = 'Scroll backward',
                mode = { 'i', 'n', 's' },
            },
        },
    },
}
