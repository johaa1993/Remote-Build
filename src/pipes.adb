package body Pipes is

   type Byte is new size_t;

   --size_t fread ( void * ptr, size_t size, size_t count, FILE * stream );
   function fread (ptr : Address; size : Byte; count : size_t; stream : Address) return size_t with Import, Convention => C, External_Name => "fread";
   function popen (command : char_array; mode : char_array) return Address with Import, Convention => C, External_Name => "popen";
   function pclose (stream : Address) return int with Import, Convention => C, External_Name => "pclose";
   function fgetc (stream : Address) return int with Import, Convention => C, External_Name => "fgetc";

   function Open_Read (Command : String) return Pipe is
      Mode : constant char_array := "r" & nul;
      Result : Address;
   begin
      Result := popen (To_C (Command), Mode);
      if Result = Null_Address then
         raise Program_Error with "popen error";
      end if;
      return Pipe (Result);
   end;

   procedure Close (Stream : Pipe) is
      Result : int;
   begin
      Result := pclose (Address (Stream));
      if Result = -1 then
         raise Program_Error with "pclose error";
      end if;
   end;

   function Get (Stream : Pipe) return Pipe_Item is
   begin
      return Pipe_Item (fgetc (Address (Stream)));
   end;

   function Component_Size (Buffer : String) return Byte is
   begin
      -- Convert bit to bytes.
      return Buffer'Component_Size / Storage_Unit;
   end;

   function Read (Stream : Pipe; Buffer : String) return Integer is
      Count : size_t;
   begin
      Count := fread (Buffer'Address, Component_Size (Buffer), Buffer'Length, Address (Stream));
      return Integer (Count);
   end;

   function Read (Stream : Pipe; Item : in out String_Stream_Container; Amount : Natural) return Boolean is
      Count : Integer;
   begin
      Count := Read (Stream, Item.Data (Item.Last + 1 .. Item.Last + Amount));
      Item.Last := Item.Last + Count;
      pragma Assert (Count < 0, "Count < 0");
      return Count > 0;
   end;

   function End_Of_File (Item : Pipe_Item) return Boolean is (Item = -1);

   function To_Ada (Item : Pipe_Item) return Character is (Character'Val (Pipe_Item'Pos (Item)));

end;
