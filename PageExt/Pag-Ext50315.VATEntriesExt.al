pageextension 50315 VATEntriesExt extends "VAT Entries"
{
    layout
    {
        //BC v28
        /*
        addafter("Type")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }


        }
        */
        addafter("Base")
        {
            field("GST Rate"; Rec."GST Rate")
            {
                ApplicationArea = all;
                Visible = False;
                Editable = true;
            }
            field("GST Exchange Rate"; Rec."GST Exchange Rate")
            {
                ApplicationArea = all;
                Visible = False;
                Tooltip = 'For GST reporting purposes, to record the exchange rate used to convert from USD to SGD.';
            }
            field("GST Amount (SGD)"; Rec."GST Amount (SGD)")
            {
                ApplicationArea = all;
                Visible = False;
                Tooltip = 'For GST reporting purposes, to record the GST amount based on SGD.';
            }
            field("Base Amount (GST)"; Rec."Base Amount (GST)")
            {
                ApplicationArea = all;
                Visible = False;
                Tooltip = 'For GST reporting purposes, to record the base amount in SGD.';
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