/* another example of parsing CSV data */

/* trace '?'r */
rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
if rcc then fail('load' rxfuncerrmsg())
call reloadfuncs

fpat = ReComp('"[^"]*"|[^,"]*', 'x')
fdel = ReComp(' *, *')

str = ' Chemical:, "1,2-Dichlorobenzene Value","1,2-Dichlorobenzene QA Flag",,,1.2345,'

i = 0
do while length(str) > 0
  if ReParse(fpat, str, 'v', 'var', 'str') then do
    i = i + 1
    csv.i = var
    /* strip the comma & spaces */
    delim = ReParse(fdel, str, 'v', 'del', 'str')
    end
  else
    leave
  end

if delim then do
  i = i + 1
  csv.i = ''
  end

csv.0 = i


  do i = 1 to csv.0  
    say i '»'csv.i'«'
    end
