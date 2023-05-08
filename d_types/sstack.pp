{sstack.pp}
unit sstack;

interface

type
	itempntr = ^StackItem;
	StackItem = record
		value: integer;
		prev: itempntr;
	end;
	Stack = record
		count: longword;
		elem: itempntr;
	end;

function CreateStack() : Stack;
function PushItem(var mstack: Stack; item: integer) : boolean;
function PopItem(var mstack: Stack; var item: integer) : boolean;
function IsEmpty(var mstack: Stack) : boolean;
function GetStackSize(var mstack: Stack) : longword;


implementation

const
	db_word = 'DEBUG';


procedure DebugPrint(var mstack: Stack);
begin
	if not IsEmpty(mstack) then
		writeln(
			db_word,
			': stack : elements = ',
			mstack.count,
			', curr value = ',
			mstack.elem^.value
			)
	else
		writeln(db_word, ': stack is empty.')
end;


function CreateStack() : Stack;
var
	new_stack: Stack;
begin
	new_stack.count := 0;
	new_stack.elem := nil;
	CreateStack := new_stack
end;


function PushItem(var mstack: Stack; item: integer) : boolean;
var
	new_stack_item: itempntr;
begin
	new(new_stack_item);
	new_stack_item^.prev := mstack.elem;
	new_stack_item^.value := item;
	mstack.elem := new_stack_item;
	mstack.count := mstack.count + 1;
	{$IFDEF DEBUG}
	DebugPrint(mstack);
	{$ENDIF}
	PushItem := not IsEmpty(mstack)
end;


function PopItem(var mstack: Stack; var item: integer) : boolean;
var
	prev_stack_item: itempntr;
	pop_success: boolean;
label
	Done;
begin
	if IsEmpty(mstack) then
	begin
		pop_success := false;
		item := 0;
		goto done;
	end;
	prev_stack_item := mstack.elem^.prev;
	item := mstack.elem^.value;
	dispose(mstack.elem);
	mstack.count := mstack.count - 1;
	mstack.elem := prev_stack_item;
	{$IFDEF DEBUG}
	DebugPrint(mstack);
	{$ENDIF}
	pop_success := true;
	Done:
	PopItem := pop_success;
end;


function IsEmpty(var mstack: Stack) : boolean;
begin
	IsEmpty := (mstack.count = 0)
end;


function GetStackSize(var mstack: Stack) : longword;
begin
	GetStackSize := mstack.count
end;

end.
