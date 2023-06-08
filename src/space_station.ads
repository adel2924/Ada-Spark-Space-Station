with Ada.Text_IO; use Ada.Text_IO;

package Space_Station with SPARK_Mode is

   subtype Distance is Integer range 0 .. Integer'Last; -- distance for orbit height
   type Module_Operation is (Add, Remove);
   type Modules_Array is array (Natural range <>) of String(1..10);

   Target_Height,Current_Height : Distance := 500;
   Crew_At_End_1, Crew_At_End_2 : Boolean := False;
   Modules : Modules_Array(1 .. 10); --array of modules strings of modules_array, 10 elements each of length 20
   Module_Count : Natural := 0; -- for count of number of modules, +/-1 when a module getted added/removed
   Inner_Door_Open, Outer_Door_Open : Boolean := False;
   Input_Str : String(1..10); -- user inputs strings length 10
   Input_Last: Natural; -- not used but Get_Line needs the second parameter for the last index of the input, its not actually used though
   Name : String(1..10) := (others => ' '); -- user input string, name of module

   procedure Update_Airlock
     with
       Pre => True,
       Post => (not (Inner_Door_Open and Outer_Door_Open));

   procedure Update_Orbit_Height
     with
       Pre => True,
       Post => (Target_Height - 25 <= Current_Height and Current_Height <= Target_Height + 25);

   procedure Manage_Module(Operation : Module_Operation; Name : String)
   with Pre => (Operation = Add and Name /= ""),
        Post => (Operation = Add and (Module_Count = Module_Count'Old + 1 and Modules(Module_Count) = Name)) or
                 (Operation = Remove and Module_Count > 0 and (Module_Count = Module_Count'Old - 1 and Modules(Module_Count+1) = "0000000000"));


   procedure Do_Spacewalk
     with
       Pre => True,
       Post => (Crew_At_End_1 and Crew_At_End_2);

   procedure Show_Current_State;

end Space_Station;
