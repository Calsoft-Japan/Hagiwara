pageextension 50000 Pag-Ext50038.ItemLedgerEntriesExtExt extends "Pag-Ext50038.ItemLedgerEntriesExt"
{
    layout
    {
        addlast(Content)
        {
                field("Product"; Rec."PRODUCT") 
                {
                    ApplicationArea = all;
                }
                field("OEMNo"; Rec."O E M NO") 
                {
                    ApplicationArea = all;
                }
                field("CustNo"; Rec."CUST NO") 
                {
                    ApplicationArea = all;
                }
                field("SBU"; Rec."S B U") 
                {
                    ApplicationArea = all;
                }
                field("g_UnitPrice"; Rec."G_ UNIT PRICE") 
                {
                    ApplicationArea = all;
                }
                field("g_UnitCost"; Rec."G_ UNIT COST") 
                {
                    ApplicationArea = all;
                }
                field("GetTrackingDate"; Rec."GET TRACKING DATE") 
                {
                    ApplicationArea = all;
                }
        }
    }
}