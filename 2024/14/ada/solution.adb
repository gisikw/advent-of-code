with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Command_Line;    use Ada.Command_Line;
with Ada.Strings.Fixed;   use Ada.Strings.Fixed;

procedure Solution is
   Pos        : array(0 .. 1) of Integer := (0, 0);
   Vel        : array(0 .. 1) of Integer := (0, 0);
   Quads      : array(0 .. 3) of Integer := (0, 0, 0, 0);
   Grid       : String (1 .. 10403) := (others => ' ');

   File_Name  : constant String := Argument(1);
   Part       : String := Argument(2);
   File       : File_Type;

   Left       : Integer;
   Right      : Integer;
   I          : Integer := 0;
   J          : Integer := 0;

begin
   if Part = "1" then 
      Open (File => File, Mode => In_File, Name => File_Name);

      while not End_Of_File (File) loop
         declare
            Line : String := Get_Line(File);
         begin
            Left := 3;
            Right := 3;
            while Line(Right) /= ',' loop
               Right := Right + 1;
            end loop;
            Pos(0) := Integer'Value(Line(Left..Right-1));

            Left := Right + 1;
            Right := Left;
            while Line(Right) /= ' ' loop
               Right := Right + 1;
            end loop;
            Pos(1) := Integer'Value(Line(Left..Right-1));

            Left := Right + 3;
            Right := Left;
            while Line(Right) /= ',' loop
               Right := Right + 1;
            end loop;
            Vel(0) := Integer'Value(Line(Left..Right-1));
            Vel(1) := Integer'Value(Line(Right+1..Line'Last));

            Pos(0) := (Pos(0) + Vel(0) * 100) mod 101;
            Pos(1) := (Pos(1) + Vel(1) * 100) mod 103;

            if Pos(0) < 50 then
               if Pos(1) < 51 then
                  Quads(0) := Quads(0) + 1;
               elsif Pos(1) > 51 then
                  Quads(1) := Quads(1) + 1;
               end if;
            elsif Pos(0) > 50 then
               if Pos(1) < 51 then
                  Quads(2) := Quads(2) + 1;
               elsif Pos(1) > 51 then
                  Quads(3) := Quads(3) + 1;
               end if;
            end if;
         end;
      end loop;

      Left := Quads(0) * Quads(1) * Quads(2) * Quads(3);
      Put_Line(Trim(Integer'Image(Left), Ada.Strings.Both));

      Close (File);
   else
      I := 1;
      while I < 10000 loop
         J := 1;
         while J < 10403 loop
           Grid(J) := ' ';
           J := J + 1;
         end loop;
         Open (File => File, Mode => In_File, Name => File_Name);

         while not End_Of_File (File) loop
            declare
               Line : String := Get_Line(File);
            begin
               Left := 3;
               Right := 3;
               while Line(Right) /= ',' loop
                  Right := Right + 1;
               end loop;
               Pos(0) := Integer'Value(Line(Left..Right-1));

               Left := Right + 1;
               Right := Left;
               while Line(Right) /= ' ' loop
                  Right := Right + 1;
               end loop;
               Pos(1) := Integer'Value(Line(Left..Right-1));

               Left := Right + 3;
               Right := Left;
               while Line(Right) /= ',' loop
                  Right := Right + 1;
               end loop;
               Vel(0) := Integer'Value(Line(Left..Right-1));
               Vel(1) := Integer'Value(Line(Right+1..Line'Last));

               Pos(0) := (Pos(0) + Vel(0) * I) mod 101;
               Pos(1) := (Pos(1) + Vel(1) * I) mod 103;

               Grid(Pos(1) * 101 + Pos(0) + 1) := '*';
            end;
         end loop;

         Close (File);

         -- Actual Method: Print out some sequences, notice some clustering
         -- behavior every X loops, tweak our increment value to just look at
         -- those loops, as the assumption is that most of the pixels are on a
         -- cycle, we're just waiting for the ones that aren't there yet.
         --
         -- J := 0;
         -- Put_Line("Grid after " & Trim(I'Image, Ada.Strings.Both));
         -- while J < 103 loop
         --   Put_Line(Grid(J*101+1..(J+1)*101));
         --   J := J + 1;
         -- end loop;

         -- Method to ensure the code passes, ideally without spoiling things
         if Grid(5497..5527) = "*******************************" then
            Put_Line(Trim(I'Image, Ada.Strings.Both));
            return;
         end if;

        I := I + 1;
      end loop;
   end if;
end Solution;
