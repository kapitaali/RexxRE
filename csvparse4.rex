/* another example of parsing CSV data */

/* trace '?'r */
rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
if rcc then fail('load' rxfuncerrmsg())
call reloadfuncs

fpat = ReComp(' *"[^"]*" *|[^,"]*', 'x')

str = ' Chemical:, "1,2-Dichlorobenzene Value","1,2-Dichlorobenzene QA Flag",,,1.2345,'

i = 0
do while length(str) > 0
  if ReExec(fpat, str, 'vars', 'p') then do
    i = i + 1
    parse var vars.!match start len
    csv.i = substr(str, start, start+len-1)
    /* skip over that field */
    str = substr(str, start+len+1)
    end
  else
    leave
  end

csv.0 = i


  do i = 1 to csv.0  
    say i '»'csv.i'«'
    end
