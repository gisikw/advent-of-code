with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Command_Line;    use Ada.Command_Line;
with Ada.Strings.Fixed;   use Ada.Strings.Fixed;

procedure Solution is
   File_Name  : constant String := Argument(1);
   Part       : String := Argument(2);
   Line       : String (1 .. 255);
   Last       : Natural;
   Line_Count : Integer := 0;
   File       : File_Type;

begin
   Open (File => File, Mode => In_File, Name => File_Name);

   while not End_Of_File (File) loop
      Get_Line (File, Line, Last);
      Line_Count := Line_Count + 1;
   end loop;

   Close (File);

   Put_Line ("Received " & Trim(Integer'Image(Line_Count), Ada.Strings.Both) &
             " lines of input for part " & Part);
end Solution;
