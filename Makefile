###
# This Makefile can be used to make a parser for the bach language
# (parser.class) and to make a program (P5.class) that tests the 
# parser and the unparse, name-analysis, and type-check methods in 
# ast.java.
#
# make clean removes all generated files
#
###

JC = javac
FLAGS = -g  
CP = ./deps:.

P5.class: P5.java parser.class Yylex.class ASTnode.class
	$(JC) $(FLAGS) -cp $(CP) P5.java

parser.class: parser.java ASTnode.class Yylex.class ErrMsg.class
	$(JC) $(FLAGS) -cp $(CP) parser.java

parser.java: bach.cup
	java -cp $(CP) java_cup.Main < bach.cup

Yylex.class: bach.jlex.java sym.class ErrMsg.class
	$(JC) $(FLAGS) -cp $(CP) bach.jlex.java

ASTnode.class: ast.java Type.java SymTab.class
	$(JC) $(FLAGS) -cp $(CP) ast.java

bach.jlex.java: bach.jlex sym.class
	java -cp $(CP) JLex.Main bach.jlex

sym.class: sym.java
	$(JC) $(FLAGS) -cp $(CP) sym.java

sym.java: bach.cup
	java -cp $(CP) java_cup.Main < bach.cup

ErrMsg.class: ErrMsg.java
	$(JC) $(FLAGS) -cp $(CP) ErrMsg.java

Sym.class: Sym.java Type.class ast.java
	$(JC) $(FLAGS) -cp $(CP) Sym.java

SymTab.class: SymTab.java Sym.class SymDuplicateException.class SymTabEmptyException.class
	$(JC) $(FLAGS) -cp $(CP) SymTab.java

Type.class: Type.java
	$(JC) $(FLAGS) -cp $(CP) Type.java ast.java

SymDuplicateException.class: SymDuplicateException.java
	$(JC) $(FLAGS) -cp $(CP) SymDuplicateException.java

SymTabEmptyException.class: SymTabEmptyException.java
	$(JC) $(FLAGS) -cp $(CP) SymTabEmptyException.java

##test
test:
	java -cp $(CP) P5 typeErrors.bach typeErrors.out
	java -cp $(CP) P5 test.bach test.out

###
# clean
###
clean:
	rm -f *~ *.class parser.java bach.jlex.java sym.java

## cleantest (delete test artifacts)
cleantest:
	rm -f *.out
