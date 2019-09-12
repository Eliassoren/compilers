%{
#include <vslc.h>
#define INT2VOIDP(i) (void*)(uintptr_t)(i)

node_t* createNode(node_index_t type, uint64_t n_children, ...)
{
    node_t* node = malloc(sizeof(node_t));
    va_list children;
    va_start(children, n_children);
    node_init(node, type, NULL, n_children, children );
    printf("%d:\t", node->n_children);
    printf("Returning create node for type %d:%s\n", type, node_string[node->type]);
    va_end(children);
    return node;
}

node_t* createNodeLabeled(node_index_t type, uint64_t n_children, void *label,
...)
{
    node_t* node = malloc(sizeof(node_t));
    va_list children;
    va_start(children, label);
    node_init(node, type, label, n_children, children);
    va_end(children);
    return node;
}
%}


%left '+' '-'
%left '*' '/'
%left '.'
%nonassoc UMINUS

%token FUNC PRINT RETURN CONTINUE IF THEN ELSE WHILE DO OPENBLOCK CLOSEBLOCK
%token VAR NUMBER IDENTIFIER STRING ASSIGN
%token START 257
%token FINISH

%define parse.error verbose

%%
program: global_list {
  root = createNode(PROGRAM, 1, $1)  
}

global_list: global { $$ = createNode(GLOBAL_LIST, 1, $1) }
  |

global:
      function {
        //root = (node_t *) malloc ( sizeof(node_t) );
        //node_init ( root, PROGRAM, NULL, 0 );
        $$ = createNode(GLOBAL_LIST, 1, $1)
      }
    ;
%%

int
yyerror ( const char *error )
{
    fprintf ( stderr, "%s on line %d\n", error, yylineno );
    exit ( EXIT_FAILURE );
}
