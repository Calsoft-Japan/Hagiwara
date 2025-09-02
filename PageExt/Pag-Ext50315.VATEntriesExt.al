pageextension 50315 VATEntriesExt extends "VAT Entries"
{
    layout
    {
        addafter("Type")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }


        }
        addafter("Base")
        {
            field("GST Rate"; Rec."GST Rate")
            {
                ApplicationArea = all;
                Visible = False;
                Editable = false;
            }
        }
        addafter("Bill-to/Pay-to No.")
        {
            field(From; Rec.From)
            {
                ApplicationArea = all;
                Visible = False;
            }
        }
    }
}