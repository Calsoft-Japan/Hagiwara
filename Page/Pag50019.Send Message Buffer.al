page 50019 "Send Message Buffer"
{
    ApplicationArea = All;
    Caption = 'Send Message Buffer';
    PageType = List;
    Editable = false;
    SourceTable = "Send Message Buffer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Export Text"; Rec."Export Text")
                {
                }
                field("Export Text 2"; Rec."Export Text 2")
                {
                }
            }
        }
    }
}
