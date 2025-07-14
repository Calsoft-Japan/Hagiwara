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

    keys
    {
        key(Key1; "Entry No.", "File ID")
        {
        }
        key(Key2; "File ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Const_JZ: Label 'JZ';

    procedure Update_MsgControl(pcod_MsgID: Code[2]; pint_RecCount: Integer; pint_AmtQty: Decimal; pint_AmtPrice: Decimal)
    var
        rec_MsgControl: Record "Message Control";
    begin
        //>>Updating Msg Control Table Info
        rec_MsgControl.RESET;
        rec_MsgControl.SETRANGE("File ID", Const_JZ);
        rec_MsgControl.SETRANGE("Detail File ID", pcod_MsgID);
        rec_MsgControl.SETRANGE("Message Status", rec_MsgControl."Message Status"::Ready);
        IF rec_MsgControl.FINDSET THEN BEGIN
            rec_MsgControl."Record Number" := rec_MsgControl."Record Number" - pint_RecCount;
            rec_MsgControl."Amount Quantity" := rec_MsgControl."Amount Quantity" - pint_AmtQty;
            rec_MsgControl."Amount Price" := rec_MsgControl."Amount Price" - pint_AmtPrice;
            rec_MsgControl.MODIFY;
        END;
        //<<
    end;
}
