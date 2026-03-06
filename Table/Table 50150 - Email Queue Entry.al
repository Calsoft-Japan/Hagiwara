table 50150 "Email Queue Entry"
{
    Caption = 'Email Queue Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(11; Type; Enum "HW Email Type")
        {
            Caption = 'Type';
        }
        field(12; "App. Entry No. / Trans. No."; Integer)
        {
            Caption = 'App. Entry No. / Transaction No.';
        }
        field(13; "IC Doc. Type"; Enum "HW Email IC Doc Type")
        {
            Caption = 'IC Doc. Type';
        }
        field(14; "IC Doc. No."; Code[20])
        {
            Caption = 'IC Doc. No.';
        }

        field(21; "Send From"; Text[250])
        {
            Caption = 'Send From';
        }
        field(22; "Send To"; Text[250])
        {
            Caption = 'Send To';
        }
        field(23; "Email Subject"; Text[250])
        {
            Caption = 'Email Subject';
        }
        field(24; "Email Body"; Text[2048])
        {
            Caption = 'Email Body';
        }
        field(101; "Sent Datetime"; DateTime)
        {
            Caption = 'Sent Datetime';
        }
        field(102; "Status"; Enum "HW Email Status")
        {
            Caption = 'Status';
        }
        field(103; "Error Msg"; Text[250])
        {
            Caption = 'Error Message';
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure GetNextNo(): Integer
    var
        EmailQueue: Record "Email Queue Entry";
    begin
        if EmailQueue.FindLast() then begin
            exit(EmailQueue."Entry No." + 1);
        end else begin
            exit(1);
        end;
    end;
}
