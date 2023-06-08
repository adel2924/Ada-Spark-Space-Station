with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Float_Random;
with Ada.Numerics.Discrete_Random;
with Ada.Containers.Vectors;

package body Space_Station with SPARK_Mode is

   procedure Update_Airlock is
   begin
      if Inner_Door_Open and Outer_Door_Open then
         Put_Line("Both airlock doors cannot be open at the same time. Closing outer door...");
         Outer_Door_Open := False;
      end if;
   end Update_Airlock;

   procedure Update_Orbit_Height is
      type RandRange is new Integer range 450 .. 550; -- Range of random numbers
      package Rand_Int is new Ada.Numerics.Discrete_Random(RandRange); -- Random number generator for integers
      Gen : Rand_Int.Generator; -- Generator for random numbers
      Num : RandRange; -- Variable to hold the generated number
   begin
      Rand_Int.Reset(Gen); -- Reset the generator
      Num := Rand_Int.Random(Gen); -- Generate a random number
   
      -- Assign the generated number to Current_Height
      Current_Height := Integer(Num);

      -- Check if the height is within the safe range
      if Current_Height < Target_Height - 25 or Current_Height > Target_Height + 25 then
         Put_Line("Orbit height of " & Integer'Image(Current_Height) & " is out of safe range, adjusting to default target height of 500");
         -- Adjust the height back to the target height
         Current_Height := Target_Height;
      end if;
   end Update_Orbit_Height;

   procedure Manage_Module(Operation : Module_Operation; Name : String) is
   begin
      -- Check operation
      case Operation is
         when Add =>
            -- Add module to list
            Put_Line("Adding module " & Name);
            Modules(Module_Count + 1) := Name;
            Module_Count := Module_Count + 1;
         when Remove =>
            -- Remove module from list
            if Module_Count > 0 then
               Put_Line("Removing module " & Modules(Module_Count));
               Modules(Module_Count) := "0000000000";
               Module_Count := Module_Count - 1;
            else
               Put_Line("Nothing to remove");
            end if;
      end case;
   end Manage_Module;

   procedure Do_Spacewalk is
      type RandRange is new Integer range 0..1;
      package Rand_Int is new Ada.Numerics.Discrete_Random(RandRange);
      Gen : Rand_Int.Generator;
      Num : RandRange;
   begin
      Rand_Int.Reset(Gen);
   
      Num := Rand_Int.Random(Gen);
      Crew_At_End_1 := (Num = 1);

      Num := Rand_Int.Random(Gen);
      Crew_At_End_2 := (Num = 1);

      if Crew_At_End_1 and Crew_At_End_2 then
         Put_Line("Spacewalk initiated. Crew members are monitoring from both ends of the station.");
      else
         Put_Line("Spacewalk cannot be initiated. There must be a crew member monitoring from each end of the station.");
         if not Crew_At_End_1 and not Crew_At_End_2 then
            Put_Line("No crew members are monitoring at either end of the station.");
         elsif not Crew_At_End_1 then
            Put_Line("No crew member is monitoring at the first end of the station.");
         else
            Put_Line("No crew member is monitoring at the second end of the station.");
         end if;
      
         Put_Line("Would you like to call a crew member to the empty end(s) of the station? (Y/N)");
         Get_Line(Input_Str,Input_Last);
      
         if Input_Str(1) = 'Y' or Input_Str(1) = 'y' then
            if not Crew_At_End_1 then
               Crew_At_End_1 := True;
               Put_Line("A crew member has been called to the first end of the station.");
            end if;
            if not Crew_At_End_2 then
               Crew_At_End_2 := True;
               Put_Line("A crew member has been called to the second end of the station.");
            end if;
            Put_Line("Spacewalk initiated.");
         else
            Put_Line("Spacewalk not initiated.");
         end if;
      end if;
   end Do_Spacewalk;

   
   procedure Show_Current_State is
   begin
      Put_Line("Space station's current state:");
      Put_Line(" - Inner door: " & (if Inner_Door_Open then "OPEN" else "CLOSED"));
      Put_Line(" - Outer door: " & (if Outer_Door_Open then "OPEN" else "CLOSED"));
      Put_Line(" - Station end 1: " & (if Crew_At_End_1 then "MONITORED" else "EMPTY"));
      Put_Line(" - Station end 2: " & (if Crew_At_End_2 then "MONITORED" else "EMPTY"));
      Put_Line(" - Orbit height: " & Distance'Image(Current_Height));
      Put_Line(" - Number of modules: " & Integer'Image(Module_Count));
      -- Print out the names of non-empty modules
      Put_Line(" - Module names:");
      for Index in Modules'Range loop
         if Modules(Index) /= "" then
            Put_Line("    - " & Modules(Index));
         end if;
      end loop;
   end Show_Current_State;

end Space_Station;
