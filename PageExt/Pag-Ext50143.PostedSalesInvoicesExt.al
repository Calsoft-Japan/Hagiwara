pageextension 50143 PostedSalesInvoicesExt extends "Posted Sales Invoices"
{
    layout
    {

        addafter("Sell-to Customer Name")
        {

            field("OEM No."; Rec."OEM No.")
            {
                ApplicationArea = All;
            }
            field("OEM Name"; Rec."OEM Name")
            {
                ApplicationArea = All;
            }

            field("Amount LCY"; "Amount LCY")
            {

                ApplicationArea = All;
            }
        }

        addafter("Ship-to Contact")
        {
            field("From"; Rec."From")
            {
                ApplicationArea = all;
                Visible = False;
            }
            field("To"; Rec."To")
            {
                ApplicationArea = all;
                Visible = False;
            }
        }
    }

    var
        "Amount LCY": Decimal;

    trigger OnAfterGetRecord()
    begin

        //SH - 4 Sep 2014
        IF Rec."Currency Factor" > 0 THEN
            "Amount LCY" := ROUND(Rec.Amount / Rec."Currency Factor")
        ELSE
            "Amount LCY" := 0;
        //End
    end;

}