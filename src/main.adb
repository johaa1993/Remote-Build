with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Pipes;

procedure Main is

   procedure Test is
      use Ada.Text_IO;
      use Ada.Integer_Text_IO;
      use Pipes;
      P : Pipe;
      Data : String_Stream_Container (5000);
      C : Character;
   begin
      P := Open_Read ("netstat");
      loop
         Put_Line ("Get_Immediate");
         Get_Immediate (C);
         exit when not Read (P, Data, 10);
         Put ("Count ");
         Put (Data.Last);
         Put_Line (Data.Data (1 .. Data.Last));
      end loop;
      Close (P);
   end;

begin

   Test;

end;

