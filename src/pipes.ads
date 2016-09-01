with System;
with Interfaces.C;

package Pipes is

   type Pipe is private;
   type Pipe_Item is private;

   type String_Stream_Container (Size : Natural);
   type String_Stream_Container (Size : Natural) is record
      Data : String (1 .. Size);
      Last : Integer := 0;
   end record;

   function Open_Read (Command : String) return Pipe;
   procedure Close (Stream : Pipe);
   function Get (Stream : Pipe) return Pipe_Item;
   function End_Of_File (Item : Pipe_Item) return Boolean;
   function To_Ada (Item : Pipe_Item) return Character;
   function Read (Stream : Pipe; Buffer : String) return Integer;
   function Read (Stream : Pipe; Item : in out String_Stream_Container; Amount : Natural) return Boolean;

private

   use System;
   use Interfaces.C;

   type Pipe is new Address;
   type Pipe_Item is new int;

end;
