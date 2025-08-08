query 50013 "Inv Val Rep with Loc & Date"
{

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            filter(Posting_Date; "Posting Date")
            {
            }
            filter(ItemNo; "Item No.")
            {
            }
            column(Item_No; "Item No.")
            {
            }
            column(Location_Code; "Location Code")
            {
            }
            column(Sum_Quantity; Quantity)
            {
                Method = Sum;
            }
        }
    }
}

