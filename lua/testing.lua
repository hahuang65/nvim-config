local augroup = require('utils').augroup

augroup('rspec', {
  'User Rails compiler rspec | set makeprg=bin/rspec'
})
