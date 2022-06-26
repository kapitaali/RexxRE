/* another example of parsing CSV data */

/* trace '?'r */
rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
if rcc then fail('load' rxfuncerrmsg())
call reloadfuncs

fpat = ReComp(' *"[^"]*" *|[^,"]*', 'x')

str = ' Chemical:, "1,2-Dichlorobenzene Value","1,2-Dichlorobenzene QA Flag",,,1.2345,'

if ReParse(fpat, str, 'vt', 'f') then do i = 1 to f.0
  say i '«' || f.i || '»'
  end
