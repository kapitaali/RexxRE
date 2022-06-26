/* example of parsing CSV data
 * there was some discussion of this in comp.text.tex
 *
 * csvparse..csvparse5 were used by my to debug some problems
 * encountered in the 1.0.0 release. I haven't taken the time to
 * comment them, but I've included them in the hopes that an example,
 * however cryptic, is better than nothing
 */

/* trace '?'r */
rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
if rcc then fail('load' rxfuncerrmsg())
call reloadfuncs
fpat = ReComp('"[^"]*"|[^,"]+', 'x')
  somestring = 'alpha,"bravo, which has a comma and ""quotes""", charlie'
  matched = ReParse(fpat, somestring, 'vt', 'FIELDS')
   say fields.0 'fields'
  do i = 1 to fields.0  
    say fields.i
    end

fpat = ReComp(' *"[^"]*" *|[^,"]*', 'x')
  somestring = 'alpha,"bravo, which has a comma and ""quotes""", charlie'
  matched = ReParse(fpat, somestring, 'vt', 'FIELDS')
   say fields.0 'fields'
  do i = 1 to fields.0  
    say fields.i
    end

fpat = ReComp(' *"[^"]*" *|[^,"]*', 'x')
  somestring = ' Chemical:, "1,2-Dichlorobenzene Value","1,2-Dichlorobenzene QA Flag",,,1.2345,'
  matched = ReParse(fpat, somestring, 'vt', 'FIELDS')
   say fields.0 'fields'
  do i = 1 to fields.0  
    say i '»'fields.i'«'
    end


fieldre = ' *("[^"]*"|[^,"]*) *'
  delimre = ','
  re = fieldre
  /* 6 is one less than the number of fields expected */
  do 6
    re = re || delimre || fieldre
    end
       
  /* reComp that if it will be used repeatedly ... */
  rere = reComp(re, 'x')

if left(rere,1) then say 'oh, poo'

say re

  if reParse(rere, somestring, 'stx', 'FIELDS') then   
    do i = 1 to fields.0
       say i fields.i
       end

