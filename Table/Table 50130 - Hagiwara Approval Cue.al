table 50130 "Hagiwara Approval Cue"
{

    Caption = 'Approval Entry';

    DrillDownPageID = "Hagiwara Approval Entries";
    LookupPageID = "Hagiwara Approval Entries";
    ReplicateData = false;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(3; "Requests to Approve"; Integer)
        {
            CalcFormula = count("Hagiwara Approval Entry" where("Approver" = field("User ID Filter"),
                                                        Open = const(true)));
            Caption = 'Requests to Approve';
            FieldClass = FlowField;
        }
        field(4; "Requests Sent for Approval"; Integer)
        {
            CalcFormula = count("Hagiwara Approval Entry" where("Requester" = field("User ID Filter"),
                                                        Open = const(true)));
            Caption = 'Requests Sent for Approval';
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

}

