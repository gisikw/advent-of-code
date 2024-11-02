with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Fixed;

procedure Solution is
   File_Name : constant String := Ada.Command_Line.Argument(1);
   Part      : String := Ada.Command_Line.Argument(2);
   Line      : String (1 .. 255);
   Last      : Natural;
   Line_Count : Integer := 0;
   File      : Ada.Text_IO.File_Type;

begin
   Ada.Text_IO.Open (File => File, Mode => Ada.Text_IO.In_File, Name => File_Name);

   while not Ada.Text_IO.End_Of_File (File) loop
      Ada.Text_IO.Get_Line (File, Line, Last);
      Line_Count := Line_Count + 1;
   end loop;

   Ada.Text_IO.Close (File);

   Ada.Text_IO.Put_Line ("Received " & 
      Ada.Strings.Fixed.Trim(Integer'Image(Line_Count), Ada.Strings.Both) & 
      " lines of input for part " & 
      Part
   );
end Solution;
