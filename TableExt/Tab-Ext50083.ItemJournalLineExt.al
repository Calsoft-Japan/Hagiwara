tableextension 50083 "Item Journal Line Ext" extends "Item Journal Line"
{
    fields
    {
        field(50001; "CO No."; Code[6])
        {
            Description = '//SiakHui: To Print  CO No. in Posted Purchase Receipt Report (ID:50018)';
        }
        field(50002; Division; Code[20])
        {
            // cleaned
        }
        field(50003; SalesPerson; Code[20])
        {
            // cleaned
        }
        field(50004; SalesPurchaser; Code[10])
        {
            // cleaned
        }
        field(50005; Applyto; Integer)
        {
            // cleaned
        }
        field(50006; "Sales Order No."; Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50007; "Purchase Order No."; Code[20])
        {
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50091; "Approval Status"; Enum "Hagiwara Approval Status")
        {
            Editable = false;
        }
        field(50092; Requester; Code[50])
        {
            Editable = false;
        }
        field(50093; "Hagi Approver"; Code[50])
        {
            Caption = 'Approver';
            Editable = false;
        }
        field(90010; "Customer Item No."; Code[20])
        {
            Editable = false;
        }
        field(90011; Rank; Code[15])
        {
            Editable = false;
        }
        field(90012; "Parts No."; Code[40])
        {
            Editable = false;
        }
    }
}
