" Rspec
augroup rspec
  autocmd BufNewFile,BufRead *_spec.rb,*_shared_examples.rb,*_shared_context.rb compiler rspec | set makeprg=bin/rspec
  
  " This needs to be set for quickfix to be correct when running tests on non-test files from vim-test
  " https://github.com/tpope/vim-rails/issues/535
  autocmd User Rails compiler rspec 
augroup END
