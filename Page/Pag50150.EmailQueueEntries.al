page 50150 "Email Queue Entries"
{
    ApplicationArea = All;
    Caption = 'Email Queue Entries';
    PageType = List;
    SourceTable = "Email Queue Entry";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Type"; Rec."Type")
                {
                }
                field("App. Entry No. / Trans. No."; Rec."App. Entry No. / Trans. No.")
                {
                }
                field("Send From"; Rec."Send From")
                {
                }
                field("Send To"; Rec."Send To")
                {
                }
                field("Email Subject"; Rec."Email Subject")
                {
                }
                field("IC Doc. Type"; Rec."IC Doc. Type")
                {
                }
                field("IC Doc. No."; Rec."IC Doc. No.")
                {
                }
                field("Sent Datetime"; Rec."Sent Datetime")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Error Msg"; Rec."Error Msg")
                {
                }
            }
        }
    }
}
