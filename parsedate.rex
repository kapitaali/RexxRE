/* RexxRE date parsing example
 *
 * This was written to verify an example from the manual.
 * The function parsedate takes a few common free-form
 * date formats and returns the likely date in date('s')
 * format.
 *
 * Copyright 2003, Patrick TJ McPhee
 * Distributed under the Mozilla Public Licence.
 * $Header: C:/ptjm/rexx/rexxre/RCS/parsedate.rex 1.1 2003/04/30 20:32:14 ptjm Rel $
 */

rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
if rcc then return 1
call reloadfuncs

say parsedate('April 30 2003')
say parsedate('30 April 2003')
/* this is a cheat -- the actual output of date is `Wed Apr 30 ...' */
say parsedate('Apr 30 15:59:27 EDT 2003')
say parsedate('30/4/2003')
say parsedate('2003/4/30')
say parsedate('2003/04/30')
say parsedate('30/04/2003')

exit 0

parsedate: procedure
mwre = ReComp('[[:alpha:]]+', 'x')
mdre = ReComp('[[:digit:]]{1,2}', 'x')
yre = ReComp('[[:digit:]]{4}', 'x')

parse arg date

pdate = date
rdate = 'baddate'

/* test for April 30 2003 */
if ReParse(mwre, pdate, 'v', 'month', 'pdate') then do
    if ReParse(mdre, pdate, 'v', 'day', 'pdate') then do
        if ReParse(yre, pdate, 'v', 'year', 'pdate') then
             rdate = year'/'mwords(month)'/'day
        end
    /* start over, trying 30 April 2003 */
    if rdate = 'baddate' then do
        pdate = date
        if ReParse(mdre, pdate, 'v', 'day', 'pdate') then do
            if ReParse(mwre, pdate, 'v', 'month', 'pdate') then do    
                if ReParse(yre, pdate, 'v', 'year', 'pdate') then
                     rdate = year'/'mwords(month)'/'right(day,2,'0')
                end
            end
        end
    end
else do
    /* test for 2003/04/30 */
    pdate = date
    if ReParse(yre, pdate, 'v', 'year', 'pdate') then do
        if ReParse(mdre, pdate, 'v', 'month', 'pdate') then do    
            if ReParse(mdre, pdate, 'v', 'day', 'pdate') then
                rdate = year'/'right(month,2,'0')'/'right(day,2,'0')
            end
        end

    /* test for 30/04/2003, then give up */
    if rdate = 'baddate' then do
        pdate = date
        if ReParse(mdre, pdate, 'v', 'day', 'pdate') then do
            if ReParse(mdre, pdate, 'v', 'month', 'pdate') then do    
                if ReParse(yre, pdate, 'v', 'year', 'pdate') then
                    rdate = year'/'right(month,2,'0')'/'right(day,2,'0')
                end
            end
        end
    end

call ReFree mwre, yre, mdre
return rdate

mwords: procedure
  mw.january = '01'
  mw.february = '02'
  mw.march = '03'
  mw.april = '04'
  mw.may = '05'
  mw.june = '06'
  mw.july = '07'
  mw.august = '08'
  mw.september = '09'
  mw.october = '10'
  mw.november = '11'
  mw.december = '12'
  mw.jan = '01'
  mw.feb = '02'
  mw.mar = '03'
  mw.apr = '04'
  mw.may = '05'
  mw.jun = '06'
  mw.jul = '07'
  mw.aug = '08'
  mw.sep = '09'
  mw.oct = '10'
  mw.nov = '11'
  mw.dec = '12'
  mw.janvier = '01'
  mw.fevrier = '02'
  mw.fev = '02'
  mw.mars = '03'
  mw.avril = '04'
  mw.avr = '04'
  mw.mai = '05'
  mw.juillet = '07'
  mw.aout = '08'
  mw.aou = '08'

  arg mon
  return mw.mon
