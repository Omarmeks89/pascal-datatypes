program s_bound_list;
{call => elem.prev^}

type
	itempntr = ^ListItem;
	ListItem = record
		value: integer;
		prev: itempntr;
	end;
	List = record
		count: longword;
		elem: itempntr;
	end;


function Makelist() : List;
var
	new_list: List;
begin
	new_list.count := 0;
	new_list.elem := nil;
	Makelist := new_list
end;


procedure AddItem(var list: List; item: integer);
{add new element to list}
{var should be in local scope}
var
	new_list_item: itempntr;
begin
	new(new_list_item);
	new_list_item^.prev := list.elem;
	new_list_item^.value := item;
	list.elem := new_list_item;
	list.count := list.count + 1
end;


procedure ClearList(var list: List);
var
	prev_list_item: itempntr;
	i: byte;
begin
	for i := list.count downto 1 do	
	begin
		prev_list_item := list.elem^.prev;
		dispose(list.elem);
		list.elem := prev_list_item;
	end;
	dispose(list.elem);
	list.count := 0;
end;


procedure PopItem(var list: List);
{pop last item}
var
	prev_list_item: itempntr;
begin
	if list.count <> 0 then
	begin
		prev_list_item := list.elem^.prev;
		dispose(list.elem);
		list.count := list.count - 1;
		list.elem := prev_list_item;
	end
	else
		writeln(ErrOutput, 'can`t delete from empty list');
end;


function IsEmpty(var list: List) : boolean;
var
	is_empty: boolean = false;
begin
	if list.count = 0 then
		is_empty := true;
	IsEmpty := is_empty
end;


function GetSize(var list: List) : longword;
begin
	GetSize := list.count
end;


procedure Run();
var
	m_list: List;
	it_pnt: itempntr;
	i: byte;
	num: integer;
begin
	{$I-}
	i := 1;
	m_list := Makelist;
	while not SeekEoln do
	begin
		read(num);
		if IOResult <> 0 then
		begin
			writeln(ErrOutput, 'invalid data ', num);
			halt(1);
		end;
		AddItem(m_list, num);
		i := i + 1;
	end;
	it_pnt := m_list.elem;
	for i := m_list.count downto 1 do
	begin
		writeln('[', i, '] ', it_pnt^.value);
		it_pnt := it_pnt^.prev;
	end;
	ClearList(m_list);
	dispose(it_pnt);
end;


begin
	Run
end.
