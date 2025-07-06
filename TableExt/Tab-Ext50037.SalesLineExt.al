tableextension 50037 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50000; "Vendor Item Number"; Text[40])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Vendor Item No." WHERE("No." = FIELD("No.")));
            Description = 'HG10.00.02 NJ 01/06/2017';
            Editable = false;
        }
        field(50010; "Customer Order No."; Text[35])
        {
            Description = '//30';
        }
        field(50011; "Customer Item No."; Code[20])
        {
            // cleaned
        }
        field(50012; "Parts No."; Code[40])
        {
            Description = '//20110427 from X30';
        }
        field(50013; Rank; Code[15])
        {
            // cleaned
        }
        field(50014; Products; Text[20])
        {
            // cleaned
        }
        field(50020; "OEM No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("Customer Type" = CONST(OEM));
        }
        field(50021; "OEM Name"; Text[50])
        {
            // cleaned
        }
        field(50500; "Shipment Seq. No."; Integer)
        {
            Editable = true;
        }
        field(50501; "Item Supplier Source"; Option)
        {
            Description = '//20101009';
            Editable = true;
            OptionCaption = ' ,Renesas';
            OptionMembers = " ",Renesas;

        }
        field(50502; "Post Shipment Collect Flag"; Integer)
        {
            // cleaned
        }
        field(50510; "Message Status"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;

        }
        field(50511; "Update Date"; Date)
        {
            // cleaned
        }
        field(50512; "Update Time"; Time)
        {
            // cleaned
        }
        field(50513; "Update By"; Code[50])
        {
            Description = '//20';
        }
        field(50514; "Next Shipment Seq. No."; Integer)
        {
            Editable = true;
        }
        field(50515; "Save Customer Order No."; Text[35])
        {
            Description = '//30//';
            Editable = false;
        }
        field(50516; "Save Posting Date"; Date)
        {
            // cleaned
        }
        field(50517; "Serial No."; Integer)
        {
            BlankZero = true;
        }
        field(50518; "Booking No."; Code[20])
        {
            Editable = true;

        }
        field(50519; "No. Series"; Code[10])
        {
            // cleaned
        }
        field(50520; "Shipped Quantity"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Shipment Line".Quantity WHERE("No." = FIELD("No."),
                                                                   "Order No." = FIELD("Document No."),
                                                                   "Line No." = FIELD("Line No."),
                                                                   Type = FIELD(Type),
                                                                   "Location Code" = FIELD("Location Code"),
                                                                   "Posting Date" = FIELD("Date Filter")));
            // cleaned
        }
        field(50521; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            // cleaned
        }
        field(50522; "JC Collection Date"; Date)
        {
            // cleaned
        }
        field(50523; "Outstanding Quantity (Actual)"; Decimal)
        {
            // cleaned
        }
        field(50524; "Actual Customer No."; Code[20])
        {
            TableRelation = Customer."No." WHERE("No." = FIELD("Actual Customer No."));
            // cleaned
        }
        field(50525; "Vendor Cust. Code"; Code[13])
        {
            // cleaned
        }
        field(50526; "PSI Process Date"; Date)
        {
            Description = '//20121103 SiakHui - use for combining 2 PSI Init jobs to 1 job enhancement';
        }
        field(50527; "Qty to Ship (2nd UOM)"; Decimal)
        {
            Caption = 'Qty tp Ship (2nd UOM)';
            DecimalPlaces = 0 : 0;
        }
        field(50528; Remarks; Text[30])
        {
            Caption = 'Remarks';
        }
        field(50535; "JA Collection Date"; Date)
        {
            // cleaned
        }
        field(50537; Revised; Code[1])
        {
            Description = '//20121114 SiakHui - use for revising JC PSI';
        }
        field(50538; "Message Status (JC)"; Option)
        {
            OptionCaption = ' ,Ready to Collect,Collected,Sent';
            OptionMembers = " ","Ready to Collect",Collected,Sent;
        }
        field(50539; "Salesperson Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
            // cleaned
        }
        field(50540; "Original Doc. No."; Code[20])
        {
            Description = '//20121215 Siakhui 0 used to store FIFO SO / SQ No.';
        }
        field(50541; Blocked; Boolean)
        {
            // cleaned
        }
        field(50542; "Original Booking No."; Code[20])
        {
            // cleaned
        }
        field(50543; "Original Line No."; Integer)
        {
            // cleaned
        }
        field(50544; "Promised Delivery Date_1"; Date)
        {
            // cleaned
        }
        field(50545; "Requested Delivery Date_1"; Date)
        {
            // cleaned
        }
        field(50546; "EDI_Lineshipment Date"; Date)
        {
            // cleaned
        }
        field(50547; "Fully Reserved"; Boolean)
        {
            Description = 'CS018';
            Editable = false;
            NotBlank = true;
        }
        field(50548; "Manufacturer Code"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Item."Manufacturer Code" WHERE("No." = FIELD("No.")));
            Description = 'CS033';
        }
        field(50550; "Line Amount to ship"; Decimal)
        {
            Caption = 'Line Amount to ship';
            Description = 'SKHE20121220';
            Editable = true;

        }
        field(50551; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
            Description = 'SKHE20140210';
            Editable = false;
        }
        field(50564; "Shipped Not Invoiced Cost(LCY)"; Decimal)
        {
            Caption = 'Shipper Not Invoiced Cost (LCY)';
            Description = '50524';
            Editable = false;
        }
        field(50565; "2nd Unit of Measure Code"; Code[10])
        {
            Caption = '2nd Unit of Measure';

        }
        field(50566; "2nd Unit of Measure"; Text[10])
        {
            Editable = false;
        }
    }

    var
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        Text031: Label 'You must either specify %1 or %2.';
        Text034: Label 'The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.';
        Text035: Label 'Warehouse ';
        Text036: Label 'Inventory ';
        HideValidationDialog: Boolean;
        Text037: Label 'You cannot change %1 when %2 is %3 and %4 is positive.';
        Text038: Label 'You cannot change %1 when %2 is %3 and %4 is negative.';
        Text039: Label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text040: Label 'You must use form %1 to enter %2, if item tracking is used.';
        Text042: Label 'When posting the Applied to Ledger Entry %1 will be opened first';
        ShippingMoreUnitsThanReceivedErr: Label 'You cannot ship more than the %1 units that you have received for document no. %2.';
        Text044: Label 'cannot be less than %1';
        Text045: Label 'cannot be more than %1';
        Text046: Label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text047: Label 'must be positive when %1 is not 0.';
        Text048: Label 'You cannot use item tracking on a %1 created from a %2.';
        Text049: Label 'cannot be %1.';
        Text051: Label 'You cannot use %1 in a %2.';
        PrePaymentLineAmountEntered: Boolean;
        Text052: Label 'You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text053: Label 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text054: Label 'Cancelled.';
        Text055: Label '%1 must not be greater than the sum of %2 and %3.', Comment = 'Quantity Invoiced must not be greater than the sum of Qty. Assigned and Qty. to Assign.';
        Text056: Label 'You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.';
        Text057: Label 'must have the same sign as the shipment';
        Text058: Label 'The quantity that you are trying to invoice is greater than the quantity in shipment %1.';
        Text059: Label 'must have the same sign as the return receipt';
        Text060: Label 'The quantity that you are trying to invoice is greater than the quantity in return receipt %1.';
        Text1500000: Label 'ONE';
        Text1500001: Label 'TWO';
        Text1500002: Label 'THREE';
        Text1500003: Label 'FOUR';
        Text1500004: Label 'FIVE';
        Text1500005: Label 'SIX';
        Text1500006: Label 'SEVEN';
        Text1500007: Label 'EIGHT';
        Text1500008: Label 'NINE';
        Text1500009: Label 'TEN';
        Text1500010: Label 'ELEVEN';
        Text1500011: Label 'TWELVE';
        Text1500012: Label 'THIRTEEN';
        Text1500013: Label 'FOURTEEN';
        Text1500014: Label 'FIFTEEN';
        Text1500015: Label 'SIXTEEN';
        Text1500016: Label 'SEVENTEEN';
        Text1500017: Label 'EIGHTEEN';
        Text1500018: Label 'NINETEEN';
        Text1500019: Label 'TWENTY';
        Text1500020: Label 'THIRTY';
        Text1500021: Label 'FORTY';
        Text1500022: Label 'FIFTY';
        Text1500023: Label 'SIXTY';
        Text1500024: Label 'SEVENTY';
        Text1500025: Label 'EIGHTY';
        Text1500026: Label 'NINETY';
        Text1500027: Label 'THOUSAND';
        Text1500028: Label 'MILLION';
        Text1500029: Label 'BILLION';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        Text1500030: Label 'NUENG';
        Text1500031: Label 'SAWNG';
        Text1500032: Label 'SARM';
        Text1500033: Label 'SI';
        Text1500034: Label 'HA';
        Text1500035: Label 'HOK';
        Text1500036: Label 'CHED';
        Text1500037: Label 'PAED';
        Text1500038: Label 'KOW';
        Text1500039: Label 'SIB';
        Text1500040: Label 'SIB-ED';
        Text1500041: Label 'SIB-SAWNG';
        Text1500042: Label 'SIB-SARM';
        Text1500043: Label 'SIB-SI';
        Text1500044: Label 'SIB-HA';
        Text1500045: Label 'SIB-HOK';
        Text1500046: Label 'SIB-CHED';
        Text1500047: Label 'SIB-PAED';
        Text1500048: Label 'SIB-KOW';
        Text1500049: Label 'YI-SIB';
        Text1500050: Label 'SARM-SIB';
        Text1500051: Label 'SI-SIB';
        Text1500052: Label 'HA-SIB';
        Text1500053: Label 'HOK-SIB';
        Text1500054: Label 'CHED-SIB';
        Text1500055: Label 'PAED-SIB';
        Text1500056: Label 'KOW-SIB';
        Text1500057: Label 'PHAN';
        Text1500058: Label 'LAAN?';
        Text1500059: Label 'PHAN-LAAN?';
        Text1500060: Label 'HUNDRED';
        Text1500061: Label 'ZERO';
        Text1500062: Label 'AND';


    procedure InitTextVariable()
    begin
        OnesText[1] := Text1500000;
        OnesText[2] := Text1500001;
        OnesText[3] := Text1500002;
        OnesText[4] := Text1500003;
        OnesText[5] := Text1500004;
        OnesText[6] := Text1500005;
        OnesText[7] := Text1500006;
        OnesText[8] := Text1500007;
        OnesText[9] := Text1500008;
        OnesText[10] := Text1500009;
        OnesText[11] := Text1500010;
        OnesText[12] := Text1500011;
        OnesText[13] := Text1500012;
        OnesText[14] := Text1500013;
        OnesText[15] := Text1500014;
        OnesText[16] := Text1500015;
        OnesText[17] := Text1500016;
        OnesText[18] := Text1500017;
        OnesText[19] := Text1500018;

        TensText[1] := '';
        TensText[2] := Text1500019;
        TensText[3] := Text1500020;
        TensText[4] := Text1500021;
        TensText[5] := Text1500022;
        TensText[6] := Text1500023;
        TensText[7] := Text1500024;
        TensText[8] := Text1500025;
        TensText[9] := Text1500026;

        ExponentText[1] := '';
        ExponentText[2] := Text1500027;
        ExponentText[3] := Text1500028;
        ExponentText[4] := Text1500029;

    end;

    procedure InitTextVariableTH()
    begin
        OnesText[1] := Text1500030;
        OnesText[2] := Text1500031;
        OnesText[3] := Text1500032;
        OnesText[4] := Text1500033;
        OnesText[5] := Text1500034;
        OnesText[6] := Text1500035;
        OnesText[7] := Text1500036;
        OnesText[8] := Text1500037;
        OnesText[9] := Text1500038;
        OnesText[10] := Text1500039;
        OnesText[11] := Text1500040;
        OnesText[12] := Text1500041;
        OnesText[13] := Text1500042;
        OnesText[14] := Text1500043;
        OnesText[15] := Text1500044;
        OnesText[16] := Text1500045;
        OnesText[17] := Text1500046;
        OnesText[18] := Text1500047;
        OnesText[19] := Text1500048;

        TensText[1] := '';
        TensText[2] := Text1500049;
        TensText[3] := Text1500050;
        TensText[4] := Text1500051;
        TensText[5] := Text1500052;
        TensText[6] := Text1500053;
        TensText[7] := Text1500054;
        TensText[8] := Text1500055;
        TensText[9] := Text1500056;

        ExponentText[1] := '';
        ExponentText[2] := Text1500057;
        ExponentText[3] := Text1500058;
        ExponentText[4] := Text1500059;
    end;


    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500061)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500060);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500062);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;


    procedure FormatNoTextTH(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500061)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500060);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text1500062);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;
}
