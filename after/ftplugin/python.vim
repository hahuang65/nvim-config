setlocal tabstop=4
setlocal shiftwidth=4

nnoremap <silent> <leader>dd :lua require('dap-python').test_method()<CR>
nnoremap <silent> <leader>dD :lua require('dap-python').test_class()<CR>
