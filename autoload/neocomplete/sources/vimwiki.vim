let s:source = {
            \ 'name': 'vimwiki',
            \ 'kind': 'ftplugin',
            \ 'filetypes': {'vimwiki': 1},
            \ 'mark': '[image]',
            \ 'max_candidates': 15,
            \ 'is_volatile' : 1,
            \ }

function! s:source.gather_candidates(context)
    let line = getline('.')
    let start = match(line, '{{.\{-}\/\zs')
    if start == -1
        return []
    endif
    let line = line[start :]
    let prefix = matchstr(line, '.*\/')
    let end = match(line, '}}$')
    let a:context.complete_str = line[len(prefix): end-1]
    let a:context.complete_pos = start+len(prefix)
    let path = g:vimwiki_list[0].path_html . prefix
    let output = system('ls ' . path)
    if output =~ 'No such file or directory'
        return []
    endif
    let list = split(output, '\n')
    return list
endfunction

function! neocomplete#sources#vimwiki#define()
    return s:source
endfunction

