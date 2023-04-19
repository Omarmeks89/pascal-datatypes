program deque;


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


procedure Run();
var
	deq: mDeque;
	m, i: integer;
	flg: boolean;
begin
	deq := CreateDeque();
	for i := 1 to 10 do 
	begin
		if i <= 5 then
		begin
			writeln('pushfr [', i * 2, ']');
			PushFront(deq, i * 2);
		end
		else
		begin
			writeln('pushbk [', i * 4, ']');
			PushBack(deq, i * 4);
		end;
	end;
	for i := deq.count downto 0 do
	begin
		flg := PopFront(deq, m);
		writeln('pop succ = ', flg, ' value = [', m, ']');
	end;
	writeln('----------------------------------');
	for i := 1 to 10 do 
	begin
		writeln('pushbk [', i * 4, ']');
		PushBack(deq, i * 4);
	end;
	for i := deq.count downto 0 do
	begin
		flg := PopFront(deq, m);
		writeln('pop succ = ', flg, ' value = [', m, ']');
	end;
end;


begin
	Run()
end.
