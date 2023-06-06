grammar example;

start: library* classes+ ;

//IMPORTING LIBRARIES//
//library: NAME (','NAME)* '=' (from)* (require)* SEMICOLON;
//from:'from' '<' NAME '>' (require|'=>') '<' NAME '>' (',' from)*;
//require: 'require' '<' NAME '>';

//CLASS DEFINITION//
//classes: 'class' NAME 'implements'  START class_body END ;//TODO
classes: 'class' NAME ('implements' NAME (',' NAME)*)? 'begin' class_body 'end';
//implements: 'implements' NAME (',' NAME)* ;
constructor: (ACCESS)? NAME '('((TYPES NAME)(',' TYPES NAME)*) ')' 'begin' (do)* 'end';
//class_body: (code)* | (constructor)*;
class_body: (code|do|constructor)*;

//.....//
object_instantiation:(ACCESS|TYPES2)? NAME ('=' NAME '(' ((DataValue)(','DataValue)*)? ')')? NAME SEMICOLON;
//functions_call: NAME ('.' NAME)* '(' ( ( DataValue | NAME ('.'NAME)+|NAME)(',' DataValue | NAME | NAME ('.'NAME)+ )* )* ')' ;
code: object_instantiation | functions | variables ;
do: variables | object_instantiation | functions_call SEMICOLON | loop_commands | conditional_commands| exceptions | condition SEMICOLON ;

//VARIABLE//
variables: (ACCESS|TYPES2)? (fVar|sVar|tVar) SEMICOLON;
fVar: (TYPES NAME ('='DataValue)? )(','DataValue'=' DataValue)*;
sVar: TYPES NAME'[]''=' DataValue TYPES '['INT']';
tVar: TYPES DataValue'[]''=' '[' (FLOAT|INT|CHAR)(','FLOAT|INT|CHAR)* ']';

loop_commands: for|while|do_while;
//FOR//
for: 'for' ('(' for_condition ')'|(NAME 'in' NAME)) 'begin' do* 'end' ;
for_condition: (TYPES NAME '=' INT SEMICOLON condition SEMICOLON condition);
//WHILE-DOWHILE//
while:'while' '(' condition ')' 'begin' do* 'end';
do_while: 'do' 'begin' do* 'end' 'while' '(' condition ')';

//conditional_commands:if|switch_case;
//IF-ELSEIF-ELSE//
//if: (if_condition) ((if_condition)| (elseIf))* (else)?;
//if_condition: 'if' '(' condition ')' 'begin' do* 'end' ;
//elseIf: 'else if' '(' condition ')' 'begin' do* 'end';
//else: 'else' 'begin' do* 'end';
//SWITCH-CASE//
///switch_case: 'switch' condition 'begin' ('case' DataValue ':' (do)? ('break' SEMICOLON)?)+ ('default' ':' do ('break' SEMICOLON)?)? 'end';

//FUNCTION DEFINITION//
///functions: (TYPES|'void') NAME '(' ((TYPES NAME)(',' TYPES NAME)*) ')' 'begin' (do)* (('return' condition SEMICOLON)*)? 'end';

//EXCEPTIONS//
///exceptions: 'try' 'begin' (do)* 'end' ('catch' '(' (NAME','NAME) ')' 'begin' (do)* 'end' )*;

//ARRANGMENTS//
//condition: '(' condition ')' | condition '**' condition | '~' condition | ('-'|'+')NAME |
//( ('++' | '--')NAME | NAME('++' | '--') ) | condition ('*' | '/' | '//' | '%') condition |
//condition ('+' | '-') condition | condition ('<<' | '>>') condition |condition ('&'|'^'|'|') condition|
//condition ('==' | '!=' | '<>') condition | condition ('<' | '>' | '<=' | '>=') condition | 'not' condition|
//condition ( 'and' | 'or' | '||' | '&&')condition |
//condition ('=' | '+=' | '-=' | '*=' | '/=') condition;
//LEXER//
fragment DIGIT:[0-9];
CHAR:([a-zA-Z] | '_' | '$');
//BEGIN: ([a-zA-Z]|'$')+;
//NAME:BEGIN (CHAR | DIGIT )+ ;
NAME: ('$'|CHAR) (CHAR | '$' | DIGIT)+;
INT:[0]|([1-9]DIGIT+) ;
FLOAT:DIGIT+('.'DIGIT+)?;
ScientificSymbols:DIGIT+|(DIGIT('.'DIGIT+)?'e'('-'|'+')? INT);
TYPES:('Int'| 'Bool'|'Double'|'String' | 'Float'|'Char');
ACCESS:('public'| 'private');
BOOL: ('True'|'False');
DataValue:( '"'  (NAME)((' ')+NAME)* '"' | INT | FLOAT | BOOL | ScientificSymbols );
TYPES2:('var'|'const');
SEMICOLON:';';
START:'begin';
END: 'end';
Return: 'return';
WS: ('\t' | '\r' | '\n' | ' ' )* -> skip;
