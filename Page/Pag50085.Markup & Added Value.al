page 50085 "Markup & Added Value"
{
    ApplicationArea = All;
    Caption = 'Markup & Added Value';
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Markup & Added Value";
    ShowFilter = true;

    layout
    {
        area(content)
        {
            group(filter)
            {
                field(ItemNoFilter; ItemNoFilter)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    ApplicationArea = All;
                }

            }
            repeater(Group)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Markup %"; Rec."Markup %")
                {
                    ApplicationArea = All;
                }
                field("Added Value"; Rec."Added Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    actions
    {
    }

    var
        ItemNoFilter: Code[30];
        StartingDateFilter: Date;
        NoDataWithinFilterErr: Label 'There is no %1 within the filter %2.';


    local procedure SetRecFilters()
    begin
        IF ItemNoFilter <> '' THEN
            Rec.SETFILTER("Item No.", ItemNoFilter)
        ELSE
            Rec.SETRANGE("Item No.");

        IF StartingDateFilter <> 0D THEN
            Rec.SETRANGE("Starting Date", StartingDateFilter)
        ELSE
            Rec.SETRANGE("Starting Date");

        CheckFilters(DATABASE::Item, ItemNoFilter);

        CurrPage.UPDATE(FALSE);
    end;

    local procedure CheckFilters(TableNo: Integer; FilterTxt: Text)
    var
        FilterRecordRef: RecordRef;
        FilterFieldRef: FieldRef;
    begin
        IF FilterTxt = '' THEN
            EXIT;
        CLEAR(FilterRecordRef);
        CLEAR(FilterFieldRef);
        FilterRecordRef.OPEN(TableNo);
        FilterFieldRef := FilterRecordRef.FIELD(1);
        FilterFieldRef.SETFILTER(FilterTxt);
        IF FilterRecordRef.ISEMPTY THEN
            ERROR(NoDataWithinFilterErr, FilterRecordRef.CAPTION, FilterTxt);
    end;

}

