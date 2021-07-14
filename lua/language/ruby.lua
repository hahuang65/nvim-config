require('augroup').create('rspec', {
  'BufNewFile,BufRead *_spec.rb,*_shared_examples.rb,*_shared_context.rb compiler rspec | set makeprg=bin/rspec'
})
