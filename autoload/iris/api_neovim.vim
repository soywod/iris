let s:job = 0

function! iris#api_neovim#start()
  let cmd = printf("python3 '%s'", iris#api#path())
  let opts = {"on_stdout": function("s:handle_stdout")}
  let s:job = jobstart(cmd, opts)
endfunction

function! s:handle_stdout(id, raw_data_list, event)
  if empty(a:raw_data_list)
    return iris#api#handle_close()
  endif

  for raw_data in a:raw_data_list
    call iris#api#handle_data(raw_data)
  endfor
endfunction

function! iris#api_neovim#send(data)
  if s:job == 0 | return | endif
  return chansend(s:job, json_encode(a:data) . "\n")
endfunction
