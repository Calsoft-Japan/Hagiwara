tableextension 55700 "Stockkeeping Unit Ext" extends "Stockkeeping Unit"
{
    fields
    {
        field(50084; "Qty. on Purch. Quote"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Quote),
                                                                              Type = CONST(Item),
                                                                              "No." = FIELD("Item No."),
                                                                              "Location Code" = FIELD("Location Code"),
                                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                              "Variant Code" = FIELD("Variant Code"),
                                                                              "Bin Code" = FIELD("Bin Filter"),
                                                                              "Expected Receipt Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 5;
        }
        field(50085; "Qty. on Sales Quote"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Outstanding Qty. (Base)" WHERE("Document Type" = CONST(Quote),
                                                                           Type = CONST(Item),
                                                                           "No." = FIELD("Item No."),
                                                                           "Location Code" = FIELD("Location Code"),
                                                                           "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                           "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                           "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                           "Variant Code" = FIELD("Variant Code"),
                                                                           "Bin Code" = FIELD("Bin Filter"),
                                                                           "Shipment Date" = FIELD("Date Filter")));
            DecimalPlaces = 0 : 5;
        }
        field(50086; "Inventory Shipped Not Inv"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Qty. Shipped Not Invoiced" WHERE("Document Type" = CONST(Order),
                                                                             Type = CONST(Item),
                                                                             "No." = FIELD("Item No."),
                                                                             "Location Code" = FIELD("Location Code"),
                                                                             "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                             "Variant Code" = FIELD("Variant Code"),
                                                                             "Shipment Date" = FIELD("Date Filter")));
            // cleaned
        }
    }
}
