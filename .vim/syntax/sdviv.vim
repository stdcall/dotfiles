syn match SdvivDictinaryName /^-->.*$/
syn match SdvivTranscription /\[[^]]\+\]/
syn match SdvivWordArticle /\<[0-9]\+\./
syn match SdvivWordMeaning /\<[0-9абвгдезжиклмнопрстуфхцчшщэюя]\+)/
syn match SdvivListItem /\(^\| \)- .*$/
syn match SdvivTerms /_\S\+\.\|\<\S\{2,5}\./

hi link SdvivDictinaryName Title
hi link SdvivTranscription Character
hi link SdvivWordArticle SubTitle
hi link SdvivWordMeaning Number
hi link SdvivListItem Comment
hi link SdvivTerms SpecialChar
