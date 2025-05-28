table 50029 "Purch. Receipt Import Staging"
{
    fields
    {
        field(1;"Entry No.";Integer)
        {
            // cleaned
        }
        field(2;Status;Option)
        {
            OptionCaption = 'Pending,Error,Processed,OK';
            OptionMembers = Pending,Error,Processed,OK;
        }
        field(3;Owner;Text[30])
        {
            // cleaned
        }
        field(4;"Receipt No.";Code[20])
        {
            // cleaned
        }
        field(5;"PO No.";Code[20])
        {
            // cleaned
        }
        field(6;"Warehouse Ref.";Code[20])
        {
            // cleaned
        }
        field(7;"Arrival Date";Date)
        {
            // cleaned
        }
        field(8;"Closed Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(9;"Item No.";Code[20])
        {
            // cleaned
        }
        field(10;"Received Qty.";Decimal)
        {
            // cleaned
        }
        field(11;"Lot No.";Code[20])
        {
            // cleaned
        }
        field(12;UOM;Code[10])
        {
            // cleaned
        }
        field(13;"Import Date";Date)
        {
            // cleaned
        }
        field(14;"Import User ID";Code[50])
        {
            // cleaned
        }
        field(15;"Batch No.";Integer)
        {
            // cleaned
        }
        field(16;"Error Description";Text[250])
        {
            // cleaned
        }
        field(17;LPN;Code[20])
        {
            // cleaned
        }
        field(18;"Imported Item No.";Code[20])
        {
            // cleaned
        }
        field(19;"Proforma Invoice";Code[35])
        {
            Description = 'HN';
        }
        field(21;"Qty. To Invoice";Decimal)
        {
            Description = 'HN';
        }
        field(22;Posted;Boolean)
        {
            Description = 'HN';
        }
        field(23;Received;Boolean)
        {
            Description = 'HN';
        }
        field(24;"CO No.";Code[6])
        {
            Description = 'HN';
        }
        field(25;Description;Code[50])
        {
            Description = 'HN';
        }
        field(26;"Unit Cost";Decimal)
        {
            DecimalPlaces = 1:4;
            Description = 'HN';
        }
        field(27;"Line No.";Integer)
        {
            Description = 'CS079';
        }
    }
}
