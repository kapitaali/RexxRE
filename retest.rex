/* RexxRE test suite.
 *
 * In contrast to, say, the RegUtil test suite, if this reports failure,
 * there's something wrong.
 *
 * Copyright 2003, Patrick TJ McPhee
 * Distributed under the Mozilla Public Licence.
 * $Header: C:/ptjm/rexx/rexxre/RCS/retest.rex 1.6 2003/05/01 15:50:26 ptjm Rel $
 */

rcc = rxfuncquery('reloadfuncs')

if rcc then do
   rcc = rxfuncadd('reloadfuncs', 'rexxre', 'reloadfuncs')
   if rcc then fail('load' rxfuncerrmsg())
   end

call reloadfuncs

say '****' parse tests

rcc = reparse('[a-z][a-z]*', 'noodles are poodles', 'v', 'n', 'a', 'p', 'd', 'x')

test = 'parse with v flag'
if \rcc then fail(test)
if n \= 'noodles' then fail(test', first variable' n)
if a \= 'are' then fail(test', second variable' a)
if p \= 'poodles' then fail(test', third variable' p)
if d \= '' then fail(test', extra variable' d)
if x \= '' then fail(test', last variable' x)
say 'pass' test

rcc = reparse('([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+)', 'I go to the store', 'xs', 'n', 'a', 'p', 'd', 'x')

test = 'parse with s flag'
if \rcc then fail(test)
if n \= 'I' then fail(test', first variable' n)
if a \= 'go' then fail(test', second variable' a)
if p \= 'to' then fail(test', third variable' p)
if d \= 'the' then fail(test', fourth variable' d)
if x \= 'store' then fail(test', last variable' x)
say 'pass' test

rcc = reparse('([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+)', 'I go to the store', 'xst', 'bo')

test = 'parse with s and t flags'
if \rcc then fail(test)
if bo.0 \= 5 then fail(test', bo.0' bo.0)
if bo.1 \= 'I' then fail(test', first variable' bo.1)
if bo.2 \= 'go' then fail(test', second variable' bo.2)
if bo.3 \= 'to' then fail(test', third variable' bo.3)
if bo.4 \= 'the' then fail(test', fourth variable' bo.4)
if bo.5 \= 'store' then fail(test', last variable' bo.5)
say 'pass' test

rcc = reparse('([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+)', 'I go to the store', 'xsc', 'n', 'a', 'p', 'd', 'x')

test = 'parse with s and c flags'
if rcc then fail(test)
if n \= '' then fail(test', first variable' n)
if a \= '' then fail(test', second variable' a)
if p \= '' then fail(test', third variable' p)
if d \= '' then fail(test', fourth variable' d)
if x \= '' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(' *[0-9]+ *', '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'x', 'n', 'a', 'p', 'd', 'x', '.')

test = 'parse with no flags, trailing dot'
if \rcc then fail(test)
if n \= '' then fail(test', first variable' n)
if a \= 'Captions' then fail(test', second variable' a)
if p \= 'Frogs' then fail(test', third variable' p)
if d \= 'Legs' then fail(test', fourth variable' d)
if x \= 'Subtitles' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(' *[0-9]+ *', '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'x', 'n', 'a', 'p', 'd', 'x')

test = 'parse with no flags'
if \rcc then fail(test)
if n \= '' then fail(test', first variable' n)
if a \= 'Captions' then fail(test', second variable' a)
if p \= 'Frogs' then fail(test', third variable' p)
if d \= 'Legs' then fail(test', fourth variable' d)
if x \= 'Subtitles 28 French 30 German' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(' *[0-9]+ *', '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'xt', 'bo')

test = 'parse with t flag'
if \rcc then fail(test)
if bo.0 \= 7 then fail(test', wrong count' bo.0)
if bo.1 \= '' then fail(test', first variable' bo.1)
if bo.2 \= 'Captions' then fail(test', second variable' bo.2)
if bo.3 \= 'Frogs' then fail(test', third variable' bo.3)
if bo.4 \= 'Legs' then fail(test', fourth variable' bo.4)
if bo.5 \= 'Subtitles' then fail(test', fifth variable' bo.5)
if bo.6 \= 'French' then fail(test', sixth variable' bo.6)
if bo.7 \= 'German' then fail(test', seventh variable' bo.7)
say 'pass' test

rcc = reparse('[a-z]+', '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'xv', 'n', 'a', 'p', 'd', 'x')

test = 'parse with v flag'
if \rcc then fail(test)
if n \= 'Captions' then fail(test', second variable' n)
if a \= 'Frogs' then fail(test', third variable' a)
if p \= 'Legs' then fail(test', fourth variable' p)
if d \= 'Subtitles' then fail(test', last variable' d)
if x \= ' 28 French 30 German' then fail(test', last variable' x)
say 'pass' test

rcc = reparse('[a-z]+', '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'xvt', 'bo')

test = 'parse with t and v flags'
if \rcc then fail(test)
if bo.0 \= 6 then fail(test', wrong count' bo.0)
if bo.1 \= 'Captions' then fail(test', first variable' bo.1)
if bo.2 \= 'Frogs' then fail(test', second variable' bo.2)
if bo.3 \= 'Legs' then fail(test', third variable' bo.3)
if bo.4 \= 'Subtitles' then fail(test', fourth variable' bo.4)
if bo.5 \= 'French' then fail(test', fifth variable' bo.5)
if bo.6 \= 'German' then fail(test', sixth variable' bo.6)
say 'pass' test

say '****' 'compiled parse tests'

cre = ReComp('[a-z][a-z]*')
test = 'compile basic'
if left(cre,1) then fail(test)
say 'pass' test

rcc = reparse(cre, 'noodles are poodles', 'v', 'n', 'a', 'p', 'd', 'x')

test = 'parse with v flag'
if \rcc then fail(test)
if n \= 'noodles' then fail(test', first variable' n)
if a \= 'are' then fail(test', second variable' a)
if p \= 'poodles' then fail(test', third variable' p)
if d \= '' then fail(test', extra variable' d)
if x \= '' then fail(test', last variable' x)
say 'pass' test

call ReFree cre

cre = ReComp('([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+)', 'x')
test = 'compile extended with subexpressions'
if left(cre,1) then fail(test)
say 'pass' test

rcc = reparse(cre, 'I go to the store', 'xs', 'n', 'a', 'p', 'd', 'x')

test = 'parse with s flag'
if \rcc then fail(test)
if n \= 'I' then fail(test', first variable' n)
if a \= 'go' then fail(test', second variable' a)
if p \= 'to' then fail(test', third variable' p)
if d \= 'the' then fail(test', fourth variable' d)
if x \= 'store' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(cre, 'I go to the store', 'xst', 'bo')

test = 'parse with s and t flags'
if \rcc then fail(test)
if bo.0 \= 5 then fail(test', bo.0' bo.0)
if bo.1 \= 'I' then fail(test', first variable' bo.1)
if bo.2 \= 'go' then fail(test', second variable' bo.2)
if bo.3 \= 'to' then fail(test', third variable' bo.3)
if bo.4 \= 'the' then fail(test', fourth variable' bo.4)
if bo.5 \= 'store' then fail(test', last variable' bo.5)
say 'pass' test

call ReFree cre

cre = ReComp('([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+) ([a-z]+)', 'xc')
test = 'compile extended with subexpressions, case-sensitive'
if left(cre,1) then fail(test)
say 'pass' test

rcc = reparse(cre, 'I go to the store', 'xsc', 'n', 'a', 'p', 'd', 'x')

test = 'parse with s and c flags'
if rcc then fail(test)
if n \= '' then fail(test', first variable' n)
if a \= '' then fail(test', second variable' a)
if p \= '' then fail(test', third variable' p)
if d \= '' then fail(test', fourth variable' d)
if x \= '' then fail(test', last variable' x)
say 'pass' test

call ReFree cre

cre = ReComp(' *[0-9]+ *', 'x')
test = 'compile extended delimiter'
if left(cre,1) then fail(test)
say 'pass' test

rcc = reparse(cre, '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'x', 'n', 'a', 'p', 'd', 'x', '.')

test = 'parse with no flags, trailing dot'
if \rcc then fail(test)
if n \= '' then fail(test', first variable' n)
if a \= 'Captions' then fail(test', second variable' a)
if p \= 'Frogs' then fail(test', third variable' p)
if d \= 'Legs' then fail(test', fourth variable' d)
if x \= 'Subtitles' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(cre, '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'x', 'n', 'a', 'p', 'd', 'x')

test = 'parse with no flags'
if \rcc then fail(test)
if n \= '' then fail(test', first variable' n)
if a \= 'Captions' then fail(test', second variable' a)
if p \= 'Frogs' then fail(test', third variable' p)
if d \= 'Legs' then fail(test', fourth variable' d)
if x \= 'Subtitles 28 French 30 German' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(cre, '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'xt', 'bo')

test = 'parse with t flag'
if \rcc then fail(test)
if bo.0 \= 7 then fail(test', wrong count' bo.0)
if bo.1 \= '' then fail(test', first variable' bo.1)
if bo.2 \= 'Captions' then fail(test', second variable' bo.2)
if bo.3 \= 'Frogs' then fail(test', third variable' bo.3)
if bo.4 \= 'Legs' then fail(test', fourth variable' bo.4)
if bo.5 \= 'Subtitles' then fail(test', fifth variable' bo.5)
if bo.6 \= 'French' then fail(test', sixth variable' bo.6)
if bo.7 \= 'German' then fail(test', seventh variable' bo.7)
say 'pass' test

call ReFree cre

cre = ReComp('[a-z]+', 'x')
test = 'compile extended'
if left(cre,1) then fail(test)
say 'pass' test

rcc = reparse(cre, '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'xv', 'n', 'a', 'p', 'd', 'x')

test = 'parse with v flag'
if \rcc then fail(test)
if n \= 'Captions' then fail(test', second variable' n)
if a \= 'Frogs' then fail(test', third variable' a)
if p \= 'Legs' then fail(test', fourth variable' p)
if d \= 'Subtitles' then fail(test', last variable' d)
if x \= ' 28 French 30 German' then fail(test', last variable' x)
say 'pass' test

rcc = reparse(cre, '17 Captions 18 Frogs 23 Legs 17 Subtitles 28 French 30 German', 'xvt', 'bo')

test = 'parse with t and v flags'
if \rcc then fail(test)
if bo.0 \= 6 then fail(test', wrong count' bo.0)
if bo.1 \= 'Captions' then fail(test', first variable' bo.1)
if bo.2 \= 'Frogs' then fail(test', second variable' bo.2)
if bo.3 \= 'Legs' then fail(test', third variable' bo.3)
if bo.4 \= 'Subtitles' then fail(test', fourth variable' bo.4)
if bo.5 \= 'French' then fail(test', fifth variable' bo.5)
if bo.6 \= 'German' then fail(test', sixth variable' bo.6)
say 'pass' test

call ReFree cre

rec = recomp('C[auo]t[a-z]*', 'c')

test = 'compile case sensitive'
if left(rec, 1) then fail(test ReError(rec))
say 'pass' test

rei = recomp('C[auo]t[a-z]*')

test = 'compile case insensitive'
if left(rei, 1) then fail(test ReError(rei))
say 'pass' test

target = 'On the cot, a catatonic cat named Catherine cut things.'
test = 'parse repeatedly with v flag, case sensitive, pass 1'
rcc = ReParse(rec, target, 'v', 'match', 'target')
if \rcc then fail(test)
if match \= 'Catherine' then fail(test', matched' match)
if target \= ' cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with v flag, case sensitive, pass 2'
rcc = ReParse(rec, target, 'v', 'match', 'target')
if rcc then fail(test)
if match \= '' then fail(test', matched' match)
if target \= ' cut things.' then fail(test', remainder' target)
say 'pass' test

target = 'On the cot, a catatonic cat named Catherine cut things.'
test = 'parse repeatedly with v flag, case insensitive, pass 1'
rcc = ReParse(rei, target, 'v', 'match', 'target')
if \rcc then fail(test)
if match \= 'cot' then fail(test', matched' match)
if target \= ', a catatonic cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with v flag, case insensitive, pass 2'
rcc = ReParse(rei, target, 'v', 'match', 'target')
if \rcc then fail(test)
if match \= 'catatonic' then fail(test', matched' match)
if target \= ' cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with v flag, case insensitive, pass 3'
rcc = ReParse(rei, target, 'v', 'match', 'target')
if \rcc then fail(test)
if match \= 'cat' then fail(test', matched' match)
if target \= ' named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with v flag, case insensitive, pass 4'
rcc = ReParse(rei, target, 'v', 'match', 'target')
if \rcc then fail(test)
if match \= 'Catherine' then fail(test', matched' match)
if target \= ' cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with v flag, case insensitive, pass 5'
rcc = ReParse(rei, target, 'v', 'match', 'target')
if \rcc then fail(test)
if match \= 'cut' then fail(test', matched' match)
if target \= ' things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with v flag, case insensitive, pass 6'
rcc = ReParse(rei, target, 'v', 'match', 'target')
if rcc then fail(test)
if match \= '' then fail(test', matched' match)
if target \= ' things.' then fail(test', remainder' target)
say 'pass' test

call ReFree rec, rei

cre = ReComp('[[:blank:]][[:blank:]]*')
test = 'compile basic with character class'
if left(cre,1) then fail(test)
say 'pass' test

target = 'On the cot, a catatonic cat named Catherine cut things.'
test = 'parse repeatedly with no flags, pass 1'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'On' then fail(test', matched' match)
if target \= 'the cot, a catatonic cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 2'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'the' then fail(test', matched' match)
if target \= 'cot, a catatonic cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 3'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'cot,' then fail(test', matched' match)
if target \= 'a catatonic cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 4'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'a' then fail(test', matched' match)
if target \= 'catatonic cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 5'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'catatonic' then fail(test', matched' match)
if target \= 'cat named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 6'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'cat' then fail(test', matched' match)
if target \= 'named Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 7'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'named' then fail(test', matched' match)
if target \= 'Catherine cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 8'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'Catherine' then fail(test', matched' match)
if target \= 'cut things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 9'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'cut' then fail(test', matched' match)
if target \= 'things.' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 10'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= 'things.' then fail(test', matched' match)
if target \= '' then fail(test', remainder' target)
say 'pass' test

test = 'parse repeatedly with no flags, pass 11'
rcc = ReParse(cre, target, , 'match', 'target')
if \rcc then fail(test)
if match \= '' then fail(test', matched' match)
if target \= '' then fail(test', remainder' target)
say 'pass' test

call ReFree cre

say '****' 'exec tests'

re = recomp('([[:digit:]]+) +([[:digit:]]+)', 'x')

test = 'compile with character class'
if left(re, 1) then fail(test ReError(re))
say 'pass' test

rcc = reexec(re, '234 159', 'bo')

test = 'exec no flags'
if \rcc then fail(test)
if bo.0 \= 2 then fail(test', count' bo.0)
if bo.1 \= 234 then fail(test', first match' bo.1)
if bo.2 \= 159 then fail(test', second match' bo.2)
if bo.!match \= '234 159' then fail(test', full match' bo.!match)
say 'pass' test

rcc = reexec(re, '234 159', 'bo', 'p')

test = 'exec p flag'
if \rcc then fail(test)
if bo.0 \= 2 then fail(test', count' bo.0)
if bo.1 \= '1 3' then fail(test', first match' bo.1)
if bo.2 \= '5 3' then fail(test', second match' bo.2)
if bo.!match \= '1 7' then fail(test', full match' bo.!match)
say 'pass' test

call ReFree re

rec = recomp('C[auo]t', 'c')

test = 'compile case sensitive'
if left(rec, 1) then fail(test ReError(rec))
say 'pass' test

rei = recomp('C[auo]t')

test = 'compile case insensitive'
if left(rei, 1) then fail(test ReError(rei))
say 'pass' test

target = 'On the cot, a catatonic cat named Catherine cut things.'

test = 'exec case sensitive'
if \ReExec(rec, target, 'bo') then fail(test)
if bo.!match \= 'Cat' then fail(test', matched' bo.!match)
say 'pass' test

test = 'exec case insensitive'
if \ReExec(rei, target, 'bo') then fail(test)
if bo.!match \= 'cot' then fail(test', matched' bo.!match)
say 'pass' test

test = 'exec positions case sensitive'
if \ReExec(rec, target, 'bo', 'p') then fail(test)
if bo.!match \= '35 3' then fail(test', matched' bo.!match)
say 'pass' test

test = 'exec positions case insensitive'
if \ReExec(rei, target, 'bo', 'p') then fail(test)
if bo.!match \= '8 3' then fail(test', matched' bo.!match)
say 'pass' test

call ReFree rec, rei

say '**** All tests passed'

exit 0

fail:
	parse arg reason
	say 'fail' reason 'at line' sigl
	exit 1
