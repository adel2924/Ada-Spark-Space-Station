with Ada.Text_IO; use Ada.Text_IO;
with Space_Station; use Space_Station;

procedure Main is

   task Controller;
   task Orbit_Height;

   task body Controller is
   begin
      loop  -- start of infinite loop
         Put_Line("Space Station Control System");
         Put_Line("Select an option for the space station:");
         Put_Line(" - 0 = Update airlock");
         Put_Line(" - 1 = Manage module (Add or Remove)");
         Put_Line(" - 2 = Initiate spacewalk");
         Put_Line(" - 3 = Show current state");
         Put_Line(" - anything else = exit space station control");
         Get_Line(Input_Str,Input_Last);

         case Input_Str(1) is
         when '0' =>
            Put_Line("Enter 1 to open or 0 to close the inner door:");
            Get_Line(Input_Str,Input_Last);
            Inner_Door_Open := (Input_Str(1) = '1');

            Put_Line("Enter 1 to open or 0 to close the outer door:");
            Get_Line(Input_Str,Input_Last);
            Outer_Door_Open := (Input_Str(1) = '1');

            Update_Airlock;
            when '1' =>
               Put_Line("Enter 1 to add a module or 2 to remove a module:");
               Get_Line(Input_Str,Input_Last);

               if Input_Str(1) = '1' then
                  Put_Line("Enter the name of the module to add:");
                  Get_Line(Input_Str,Input_Last);
                  Manage_Module(Add, Input_Str);
               elsif Input_Str(1) = '2' then
                  Manage_Module(Remove, "");
               else
                  Put_Line("Invalid entry, please try again.");
               end if;

            when '2' =>
               Do_Spacewalk;
            when '3' =>
               Show_Current_State;
            when others =>
               Put_Line("Exiting...");
               exit;
         end case;
         Put_Line("");
      end loop;  -- end of infinite loop
   end Controller;

   task body Orbit_Height is
   begin
      loop
         delay 10.0;  -- Delay for 10 seconds
         Update_Orbit_Height; -- Call Update_Orbit_Height periodically
      end loop;
   end Orbit_Height;


begin
   null;
end Main;
