require('lualine').setup {
    options = {
        theme = 'ayu_dark',
        globalstatus = true,
        component_separators = '|',
        section_separators = '',
    },
    sections = {
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 1
            },
        },
        lualine_x = {
            {
                'lsp_progress',
                display_components = { { 'title', 'message' } },
            },
        },
        lualine_y = { 'encoding', 'fileformat', 'filetype' },
        lualine_z = { "os.date('%d %b')", "os.date('%H:%M')" }
    },
}
