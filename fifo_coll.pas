program fifo_coll;


type
	itempntr = ^ListItem;
	ListItem = record
		value: integer;
		next: itempntr;
	end;
	FifoList = record
		count: longword;
		first_item: itempntr;
		last_item: itempntr;
		curr_item: itempntr;
	end;


function MakeFifoList() : FifoList;
var
	new_list: FifoList;
begin
	new_list.count := 0;
	new_list.first_item := nil;
	new_list.last_item := nil;
	new_list.curr_item := nil;
	MakeFifoList := new_list
end;


procedure PutItem(var F_List: FifoList; value: integer);
var
	new_list_item: itempntr;
	last_item_in_list: itempntr;
begin
	new(new_list_item);
	new_list_item^.next := nil;
	if F_List.count = 0 then
	begin
		F_List.first_item := new_list_item;
		F_List.last_item := new_list_item;
	end
	else
	begin
		last_item_in_list := F_List.last_item;
		last_item_in_list^.next := new_list_item;
		F_List.last_item := new_list_item;
	end;
	new_list_item^.value := value;
	F_List.count := F_List.count + 1;
end;


function GetItem(var F_List: FifoList) : integer;
var
	value: integer;
begin
	if F_List.count = 0 then
	begin
		writeln(ErrOutput, 'empty collection, <get> not allowed');
		halt(1);
	end;
	if F_List.curr_item = nil then
		F_List.curr_item := F_List.first_item;
	value := F_List.curr_item^.value;
	F_List.curr_item := F_List.curr_item^.next;
	GetItem := value
end;
		

function PopItem(var F_List: FifoList) : integer;
var
	value: integer;
	next_item: itempntr;
begin
	if F_List.first_item = nil then
	begin
		writeln(ErrOutput, 'empty collection, <pop> not allowed');
		halt(1);
	end;
	next_item := F_List.first_item^.next;
	value := F_List.first_item^.value;	
	dispose(F_List.first_item);
	F_List.count := F_List.count - 1;

	if F_List.count = 0 then
	begin
		F_List.last_item := nil;
		if F_List.curr_item <> nil then
			dispose(F_List.curr_item)
	end;
	F_List.first_item := next_item;
	PopItem := value;
end;


procedure Run();
var
	fifo_lst: FifoList;
	value, num: integer;
	i: integer;
begin
	{$I-}
	i := 1;
	fifo_lst := MakeFifoList;
	while not SeekEoln do
	begin
		read(num);
		If IOResult <> 0 then
		begin
			writeln(ErrOutput, 'invalid data: ', num);
			halt(1);
		end;
		writeln('<PUT>: ', num);
		PutItem(fifo_lst, num);
		i := i + 1;
	end;
	for i := fifo_lst.count downto 1 do
	begin
		value := GetItem(fifo_lst);
		writeln('<GET> value = ', value);
	end;
end;
	

begin
	Run()
end.
