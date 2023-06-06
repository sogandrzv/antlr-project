grammar sm;
start: library* classes+ ;

//IMPORTING LIBRARIES//
library: NAME (','NAME)* '=' (from)* (require)* SEMICOLON;
from:'from' '<' NAME '>' (require|'=>') '<' NAME '>' (',' from)*;
require: 'require' '<' NAME '>' (','from)?;
//CLASS DEFINITION//
classes: 'class' NAME (ext)? ('implements' NAME (','NAME)*)? 'begin' (object_instantiation|variables|functions|constructor|do)* 'end';
ext: '(' NAME ')';


//VARIABLE//
variables: ACCESS? (fVar|sVar) SEMICOLON;
fVar: (TYPES (NAME|CHAR) ('='DataValue)? )(','(NAME|CHAR)'=' DataValue)*;
sVar: TYPES (NAME|CHAR)'[]''=' ('new' TYPES '['DataValue']' | '[' (DataValue)(','DataValue)* ']');
//ARRANGMENTS//
condition: '(' (NAME|CHAR)('.'(NAME|CHAR))* ')' |
(NAME|CHAR) '?' DATAVALLUE2 ':' DATAVALLUE2|
'return' (NAME|CHAR) '?' DATAVALLUE2 ':' condition |
'return'(NAME|CHAR) |
DataValue '**' DataValue |
'~' DataValue |
('-'|'+')(NAME|CHAR) |
( ('++' | '--')(NAME|CHAR) | (NAME|CHAR)('++' | '--') )|
condition ('*' | '/' | '//' | '%') (DataValue|NAME|CHAR)|
condition ('+' | '-') (condition|DataValue)|
condition ('<<' | '>>') (condition|DataValue)|
condition ('&'|'^'|'|') (condition|DataValue)|
condition ('==' | '!=' | '<>') (condition|DataValue)|
condition('<' | '>' | '<=' | '>=') (DataValue|NAME|CHAR)|
'not' (DataValue|NAME|CHAR)|
condition ( 'and' | 'or' | '||' | '&&')condition|
(NAME|CHAR) ('=' | '+=' | '-=' | '*=' | '/=') (DataValue|NAME|CHAR)|(NAME|CHAR)('.'(NAME|CHAR))*|
'!'(((NAME|CHAR)('.' (NAME|CHAR))*));
//
object_instantiation:(ACCESS|TYPES2)? NAME NAME ('=' NAME '(' ((DataValue)(','DataValue)*)? ')')? NAME SEMICOLON;
do: variables |loop_commands|conditional_commands|exceptions|functions_call|
object_instantiation | condition SEMICOLON|print SEMICOLON ;
//
loop_commands: for|for2|while|do_while;
//FOR//
for: 'for' '(' TYPES? (NAME|CHAR) '=' DataValue SEMICOLON condition SEMICOLON condition ')' 'begin' (do)* 'end';
for2: 'for' (NAME|CHAR) 'in' NAME 'begin' do* 'end';
//WHILE-DOWHILE//
while:'while' '(' condition ')' 'begin' do* 'end';
do_while: 'do' 'begin' do* 'end' 'while' '(' condition ')';
conditional_commands:if|switch_case;
//IF-ELSEIF-ELSE//
if: (if_condition) ((if_condition)| (elseIf))* (else)?;
if_condition: 'if' '(' condition ')' 'begin' do* 'end' ;
elseIf: 'else if' '(' condition ')' 'begin' do* 'end';
else: 'else' 'begin' do* 'end';
//SWITCH-CASE//
switch_case: 'switch' condition 'begin' ('case' DATAVALLUE2 ':' (do)?
('break' SEMICOLON)?)+ ('default' ':' do*)? 'end';
//FUNCTION DEFINITION//
functions: (TYPES|'void') NAME '(' ((TYPES NAME)(',' TYPES NAME)*) ')' 'begin' (do)* return 'end';
constructor: (ACCESS)? NAME '('((TYPES NAME)(',' TYPES NAME)*) ')' 'begin' (do)* 'end';
arg: functions_call | INT | FLOAT | BOOL | ScientificSymbols | NAME | condition;
functions_call:NAME ('.' NAME)* '(' (arg(','arg)*)? ')' SEMICOLON;
return: 'return' NAME(','NAME)* SEMICOLON;
//EXCEPTIONS//
exceptions: 'try' 'begin' (do)* 'end' ('catch' '(' (NAME','NAME) ')' 'begin' (do)* 'end' )*;
//PRINT//
print:'print(' ('"'(NAME|DataValue)'"')|('\''CHAR'\'')?')' SEMICOLON;//TODO

//LEXER//
TYPES:('int'| 'bool'|'double'|'string' | 'float'|'char');
DataValue:( INT | FLOAT | BOOL | ScientificSymbols );
DIGIT:[0-9];
CHAR:([a-zA-Z] | '_' | '$');
TYPES2:('var'|'const');
ACCESS:('public'| 'private');
NAME: ('$'|CHAR) (CHAR | '$' | DIGIT)+;
INT:[0]|([1-9]DIGIT+) ;
FLOAT:DIGIT+('.'DIGIT+)?;
ScientificSymbols:DIGIT+|(DIGIT('.'DIGIT+)?'e'('-'|'+')? INT);
BOOL: ('True'|'False');
DATAVALLUE2:('"'  (NAME)((' ')+NAME)* '"' |  INT | FLOAT | BOOL | ScientificSymbols);
SEMICOLON:';';
COMMENTS: (('//'|'/') (CHAR | DIGIT)* | '/*' ( CHAR | DIGIT | '\n' | '\t' | '\r' )* '*/')+ -> skip;
WS: ('\t' | '\r' | '\n' | ' ' )* -> skip;