table 50129 "Hagiwara Approval Entry"
{

    fields
    {

        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Data; Option)
        {
            OptionMembers = "","Customer","Vendor","Item","G/L Account","Price List","Sales Order","Purchase Order","Sales Credit Memo","Purchase Credit Memo","Sales Return Order","Purchase Return Order","Item Reclass Journal","Transfer Order","Item Journal","Assembly Order";
        }
        field(3; "No."; Code[20])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }
        field(4; "Requester"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(5; "Request Group"; Code[30])
        {
            TableRelation = "Hagiwara Request Group".Code;
        }
        field(6; "Approver"; Code[50])
        {
            TableRelation = User."User Name";
        }
        field(7; "Approval Group"; Code[30])
        {
            TableRelation = "Hagiwara Approval Group".Code;
        }
        field(8; "Approval Sequence No."; Integer)
        {
        }
        field(9; "Request Date"; Date)
        {

        }
        field(10; Status; Option)
        {
            OptionMembers = "","Submitted","Re-Submitted","Cancelled","Approved","Rejected","Auto Approved";
        }
        field(11; Comment; Blob)
        {
        }
        field(12; Open; Boolean)
        {
            InitValue = true;
        }
        field(13; "Close Date"; Date)
        {

        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

}

