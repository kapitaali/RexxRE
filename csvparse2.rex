/* another example of parsing CSV data */

/* trace '?'r */
rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
if rcc then fail('load' rxfuncerrmsg())
call reloadfuncs

  somestring = ' Chemical:, "1,2-Dichlorobenzene Value","1,2-Dichlorobenzene QA Flag",,,1.2345,'

fieldre = '("[^"]*"|[^,"]*)'
  delimre = ' *, *'
  re = fieldre
  /* 6 is one less than the number of fields expected */
  do 6
    re = re || delimre || fieldre
    end
       
  /* reComp that if it will be used repeatedly ... */
  rere = reComp(re, 'x')

if left(rere,1) then say 'oh, poo'

  if reParse(rere, somestring, 'stx', 'FIELDS') then   
    do i = 1 to fields.0
       say i fields.i
       end

