grammar Project;
//START//
start: library* classes+ ;


//IMPORTING LIBRARIES//
library: NAME(','NAME)* '=' (require|from|from2) (','(require|from|from2))* SEMICOLON;
require: 'require' '<'NAME'>';
from:'from' '<'NAME'>' 'require' '<'NAME'>';
from2: 'from' '<'NAME'>' '=>' '<'NAME'>';



//CLASS DEFINITION//
classes: 'class' NAME (ext)? ('implements' NAME (','NAME)*)? 'begin' (object_instantiation|variables|functions|constructor|do)* 'end';
ext: '(' NAME ')';


//VARIABLE//
variables: ACCESS? (fVar|sVar) SEMICOLON;
fVar: (TYPES (NAME|CHAR) ('='DATAVALUE)? )(','(NAME|CHAR)('='DATAVALUE)?)*;
sVar: TYPES (NAME|CHAR)'[]''=' ('new' TYPES '['DATAVALUE']' | '[' (DATAVALUE)(','DATAVALUE)* ']');


//ARRANGMENTS//
condition: '(' (NAME|CHAR) ('.' (NAME|CHAR))* ')' |
(NAME|CHAR) '?' DATAVALLUE2 ':' DATAVALLUE2|
'return' ((NAME|CHAR) ('.' (NAME|CHAR))*|CHAR) '?' DATAVALLUE2 ':' condition |
'return'(NAME|CHAR) |
DATAVALUE '**' DATAVALUE |
'~' DATAVALUE |
('-'|'+')(NAME|CHAR) |
( ('++' | '--')(NAME|CHAR) ('.' (NAME|CHAR))* | (NAME|CHAR) ('.' (NAME|CHAR))*('++' | '--') )|
condition ('*' | '/' | '//' | '%') (DATAVALUE|NAME|CHAR)|
condition ('+' | '-') (condition|DATAVALUE)|
condition ('<<' | '>>') (condition|DATAVALUE)|
condition ('&'|'^'|'|') (condition|DATAVALUE)|
condition ('==' | '!=' | '<>') (condition|DATAVALUE)|
condition('<' | '>' | '<=' | '>=') (DATAVALUE|NAME|CHAR)|
'not' (DATAVALUE|NAME|CHAR)|
condition ( 'and' | 'or' | '||' | '&&')condition|
(NAME|CHAR)('.'(NAME|CHAR))* ('=' | '+=' | '-=' | '*=' | '/=') (DATAVALUE|NAME|CHAR)|(NAME|CHAR)('.'(NAME|CHAR))*|
'!'((NAME|CHAR)('.' (NAME|CHAR))*);


//**//
object_instantiation:(ACCESS|TYPES2)? NAME NAME ('=' NAME'('((DATAVALUE)(','DATAVALUE)*)?')')? SEMICOLON;
do: variables |loop_commands|conditional_commands|exceptions|functions_call|object_instantiation | condition SEMICOLON|print;


loop_commands: for|for2|while|do_while;


//FOR//
for: 'for' '(' TYPES? (NAME|CHAR) '=' DATAVALUE SEMICOLON condition SEMICOLON condition ')' 'begin' (do)* 'end';
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
functions: (TYPES|'void') NAME '(' ((TYPES NAME)(',' TYPES NAME)*) ')' 'begin' (do)* (return)? 'end';
constructor: (ACCESS)? NAME '('((TYPES NAME)(',' TYPES NAME)*) ')' 'begin' (do)* 'end';
arg: functions_call | INT | FLOAT | BOOL | ScientificSymbols | NAME | condition;
functions_call:NAME ('.' NAME)* '(' (arg(','arg)*)? ')' SEMICOLON;
return: 'return' NAME(','NAME)* SEMICOLON;


//EXCEPTIONS//
exceptions: 'try' 'begin' (do)* 'end' ('catch' '(' (NAME','NAME) ')' 'begin' (do)* 'end' )*;


//PRINT//
print: 'print''('('"'(NAME|CHAR)('.'(NAME|CHAR))* '"')? ')' SEMICOLON;


//LEXER//
TYPES:('int'| 'bool'|'double'|'string' | 'float'|'char'|'string');
DATAVALUE:( INT | FLOAT | BOOL | SCIENTIFICNUMBER);
DIGIT:[0-9];
CHAR:([a-zA-Z] | '_' | '$');
TYPES2:('var'|'const');
ACCESS:('public'| 'private');
//DATAVALUE3:('"' (NAME|CHAR)('.' (NAME|CHAR))* '"');
NAME: ('$'|CHAR) (CHAR | '$' | DIGIT)+;
INT:[0]|([1-9]DIGIT+);
FLOAT:DIGIT+('.'DIGIT+)?;
SCIENTIFICNUMBER:DIGIT+|(DIGIT('.'DIGIT+)?'e'('-'|'+')? INT);
BOOL: ('True'|'False');
DATAVALLUE2:('"'  (NAME)((' ')+NAME)* '"' |  INT | FLOAT | BOOL | SCIENTIFICNUMBER);
SEMICOLON:';';
COMMENTS: (('//'|'/') (CHAR | DIGIT|NAME|'\t''\n'|' ')*)+ -> skip;
WS: ('\t' | '\r' | '\n' | ' ' )* -> skip;