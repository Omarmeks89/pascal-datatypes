{sdeque.pp}
unit sdeque;


interface

type
	itempntr = ^DequeItem;
	DequeItem = record
		value: integer;
		prev, next: itempntr;
	end;
	mDeque = record
		count: longword;
		first, last: itempntr;
	end;


procedure PushFront(var dq: mDeque; value: integer);
procedure PushBack(var dq: mDeque; value: integer);
function PopFront(var dq: mDeque; var value: integer) : boolean;
function PopBack(var dq: mDeque; var value: integer) : boolean;


implementation

function IsEmpty(var dq: mDeque) : boolean;
begin
	IsEmpty := dq.count = 0
end;


procedure IncrementDeqCount(var dq: mDeque);
begin
	dq.count := dq.count + 1
end;


procedure DecrementDeqCount(var dq: mDeque);
begin
	dq.count := dq.count - 1
end;


function CreateDeque() : mDeque;
var
	n_deque: mDeque;
begin
	n_deque.count := 0;
	n_deque.first := nil;
	n_deque.last := nil;
	CreateDeque := n_deque
end;


procedure PushFront(var dq: mDeque; value: integer);
{before new - nil, after - first, we go to right.}
var
	new_item: itempntr;
begin
	new(new_item);
	new_item^.value := value;
	new_item^.prev := nil;
	new_item^.next := dq.first;
	if IsEmpty(dq) then
		dq.last := new_item
	else
		dq.first^.prev := new_item;
	dq.first := new_item;
	IncrementDeqCount(dq)
end;


procedure PushBack(var dq: mDeque; value: integer);
var
	new_item: itempntr;
begin
	new(new_item);
	new_item^.value := value;
	new_item^.prev := dq.last;
	new_item^.next := nil;
	if IsEmpty(dq) then
		dq.first := new_item
	else
		dq.last^.next := new_item;
	dq.last := new_item;
	IncrementDeqCount(dq)
end;


function PopFront(var dq: mDeque; var value: integer) : boolean;
var
	curr_item: itempntr;
begin
	if IsEmpty(dq) then
	begin
		PopFront := false;
		exit
	end;
	curr_item := dq.first^.next;
	if curr_item <> nil then
		curr_item^.prev := nil
	else
		dq.last := curr_item;
	value := dq.first^.value;
	dispose(dq.first);
	dq.first := curr_item;
	DecrementDeqCount(dq);
	PopFront := true
end;


function PopBack(var dq: mDeque; var value: integer) : boolean;
var
	curr_item: itempntr;
begin
	if IsEmpty(dq) then
	begin
		PopBack := false;
		exit
	end;
	curr_item := dq.last^.prev;
	if curr_item <> nil then
		curr_item^.next := nil
	else
		dq.first := curr_item;
	value := dq.last^.value;
	dispose(dq.last);
	dq.last := curr_item;
	DecrementDeqCount(dq);
	PopBack := true
end;

end.
