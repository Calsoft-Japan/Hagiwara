table 50006 "Message Control"
{
    fields
    {
        field(1; "Entry No."; Integer)
        {
            // cleaned
        }
        field(20; "File ID"; Code[2])
        {
            // cleaned
        }
        field(30; "Detail File ID"; Code[3])
        {
            // cleaned
        }
        field(40; "Record Number"; Integer)
        {
            // cleaned
        }
        field(50; "Pos/Neg Class (Quantity)"; Text[1])
        {
            // cleaned
        }
        field(60; "Amount Quantity"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(70; "Pos/Neg Class (Price)"; Text[1])
        {
            // cleaned
        }
        field(80; "Amount Price"; Decimal)
        {
            DecimalPlaces = 0 : 3;
        }
        field(90; "Statics Date"; Date)
        {
            // cleaned
        }
        field(100; "Order Backlog Date"; Date)
        {
            Description = 'Now not in Use';
        }
        field(200; Preliminaries; Text[191])
        {
            // cleaned
        }
        field(50000; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready,Sent';
            OptionMembers = " ",Ready,Sent;
        }
        field(50001; "Collected By"; Code[50])
        {
            Description = '//sh 20140715 (20 to 50)';
            Editable = false;
        }
        field(50002; "Collected On"; Date)
        {
            Editable = true;
        }
        field(50003; "File Sent By"; Code[50])
        {
            Description = '//sh 20140715 (20 to 50)';
            Editable = false;
        }
        field(50004; "File Sent On"; Date)
        {
            Editable = true;
        }
    }
}
