report 50033 "Export Business Data"
{
    // CS092 FDD DE01 Bobby.Ji 2025/9/1 - Germany Localization-Export Business Data (GDPdU)
    ProcessingOnly = true;
    Caption = 'Export Business Data';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {

    }


    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the start date for the data export.';
                    }
                    field(EndingDate; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the end date for the data export.';
                    }
                    field(IncludeClosingDate; ShowExpected)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Closing Date';
                        ToolTip = 'Specifies if the data export must include the closing date for the period.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            AccPeriod: Record "Accounting Period";
        begin
            StartDate := AccPeriod.GetFiscalYearStartDate(WORKDATE);
            EndDate := WORKDATE;
        end;
    }

    labels
    {
    }
    trigger OnInitReport()
    begin
        Clear(FileCount);
        CurrReport.FormatRegion('de-DE');

    end;

    trigger OnPreReport()
    begin
        IF StartDate = 0D THEN
            ERROR(StartDateErr);

        IF EndDate = 0D THEN
            ERROR(EndDateErr);
        /*
        if not ShowExpected then begin
            EndDate := EndDate - 1;
        end;*/

        StartTime := CurrentDateTime;
        FillCharsToDelete();
        ExportZipFile();

    end;

    var
        PackageCode: Label 'GDPDU';
        StartDate: Date;
        EndDate: Date;
        ShowExpected: Boolean;
        FileCount: array[17] of Integer;
        TableName: array[17] of Text;
        ExportFileName: array[17] of Text;
        OriginalCulture: Integer;
        OriginalDecimalSep: Char;
        OriginalThousandSep: Char;
        IsSwitched: Boolean;
        StartDateErr: Label 'You must enter a starting date.';
        EndDateErr: Label 'You must enter an ending date.';
        LogEntryMsg: Label 'For table %1, %2 data records were exported, and file %3 was created.';
        NoOfDefinedTablesMsg: Label 'Number of defined tables: %1.';
        NoOfEmptyTablesMsg: Label 'Number of empty tables: %1.';
        DurationMsg: Label 'Duration: %1.';
        StartTime: DateTime;
        datacompresion: Codeunit "Data Compression";
        GLSetup: Record "General Ledger Setup";
        ValueWithQuotesMsg: Label '"%1"';
        NewLine: Text;
        CharsToDelete: Text;

    procedure ExportZipFile()
    var
        ZipedFile: OutStream;
        ZipStream: InStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
    begin
        datacompresion.CreateZipArchive();

        ExportDataFile();
        ExportXML();

        ExportTextFile('Log.txt', PrepareLogtoTextContent());
        ExportDTDFile();

        TempBlob.CreateOutStream(ZipedFile);
        datacompresion.SaveZipArchive(ZipedFile);
        datacompresion.CloseZipArchive();
        TempBlob.CreateInStream(ZipStream);
        FileName := 'Export Business Data' + Format(Today()) + '.zip';
        DownloadFromStream(ZipStream, 'Dialog', 'Folder', '', FileName);
    end;

    procedure ExportTextFile(FileName: Text; Content: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
    begin
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Content);
        TempBlob.CreateInStream(InStr);
        datacompresion.AddEntry(InStr, FileName);
    end;

    local procedure ExportDataFile()
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        ConfigPackageTable: Record "Config. Package Table";
        ConfigPackageField: Record "Config. Package Field";
        TempConfigPackageField: Record "Config. Package Field" temporary;
        ConfigPackageFilter: Record "Config. Package Filter";
        ContentBuilder: TextBuilder;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        i: Integer;
        j: Integer;
        n: Integer;
        FieldValue: Text;
        FileName: Text;
        Value: Variant;
        FlowFieldList: List of [Integer];
    begin
        i := 1;
        ConfigPackageTable.Reset();
        ConfigPackageTable.SetRange("Package Code", PackageCode);
        ConfigPackageTable.SetAutoCalcFields("Table Name");
        ConfigPackageTable.SetCurrentKey("Processing Order");
        if ConfigPackageTable.FindFirst() then begin
            repeat
                FileName := ConfigPackageTable."Export Field Name";
                ContentBuilder.Clear();
                RecordRef.OPEN(ConfigPackageTable."Table ID");
                RecordRef.Reset();

                for n := 1 to RecordRef.FieldCount do begin
                    FieldRef := RecordRef.FieldIndex(n);
                    if FieldRef.Class = FieldClass::FlowField then
                        RecordRef.SetAutoCalcFields(FieldRef.Number);
                end;

                ConfigPackageFilter.Reset();
                ConfigPackageFilter.SetRange("Package Code", PackageCode);
                ConfigPackageFilter.SetRange("Table ID", ConfigPackageTable."Table ID");
                ConfigPackageFilter.SetAutoCalcFields("Field Name");

                if ConfigPackageFilter.FindFirst() then begin

                    RecordRef.Ascending := true;
                    case ConfigPackageTable."Table ID" of
                        17:
                            begin
                                RecordRef.SetView('SORTING(G/L Account No.,Entry No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        21:
                            begin
                                RecordRef.SetView('SORTING(Customer No.,Entry No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        25:
                            begin
                                RecordRef.SetView('SORTING(Vendor No.,Entry No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        32:
                            begin
                                RecordRef.SetView('SORTING(Item No.,Entry No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        112:
                            begin
                                RecordRef.SetView('SORTING(No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        254:
                            begin
                                RecordRef.SetView('SORTING(Entry No.,Document No,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        379:
                            begin
                                RecordRef.SetView('SORTING(Customer No.,Entry No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        380:
                            begin
                                RecordRef.SetView('SORTING(Vendor No.,Entry No.,' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                            end;
                        else begin
                            RecordRef.SetView('SORTING(' + ConfigPackageFilter."Field Name" + ') Order(Ascending)');
                        end;
                    end;

                    FieldRef := RecordRef.Field(ConfigPackageFilter."Field ID");
                    FieldRef.SetRange(StartDate, EndDate);
                end;

                FileCount[i] := RecordRef.Count;
                TableName[i] := ConfigPackageTable."Table Name";
                ExportFileName[i] := ConfigPackageTable."Export Field Name";
                if RecordRef.FindSet() then
                    repeat
                        j := 1;
                        FieldValue := '';

                        ConfigPackageField.Reset();
                        ConfigPackageField.SetRange("Package Code", PackageCode);
                        ConfigPackageField.SetRange("Table ID", ConfigPackageTable."Table ID");
                        ConfigPackageField.SetRange("Include Field", true);
                        if ConfigPackageField.FindSet() then begin
                            CollectField(ConfigPackageField, TempConfigPackageField);
                            DeleteKeyToConfigPackage(TempConfigPackageField, PackageCode, ConfigPackageTable."Table ID");
                            AddFieldsToConfigPackage(TempConfigPackageField, PackageCode, ConfigPackageTable."Table ID");
                        end;
                        if (ConfigPackageTable."Table ID" = 112) OR (ConfigPackageTable."Table ID" = 114) then
                            TempConfigPackageField.SetCurrentKey("Processing Order")
                        else
                            TempConfigPackageField.SetCurrentKey("Field ID");
                        if TempConfigPackageField.FindSet() then begin
                            repeat
                                FieldValue += FormatFieldValue(RecordRef.Field(TempConfigPackageField."Field ID"), RecordRef);

                                if j < TempConfigPackageField.Count then
                                    FieldValue += ';';
                                j := j + 1;
                            until TempConfigPackageField.Next() = 0;
                        end;

                        ContentBuilder.AppendLine(FieldValue);
                    until RecordRef.Next() = 0;

                i := i + 1;
                ExportTextFile(FileName, ContentBuilder.ToText());
                RecordRef.Close();
            until ConfigPackageTable.Next() = 0;
        end;

    end;

    local procedure FormatFieldValue(FieldRef: FieldRef; RecordRef: RecordRef): Text
    var
        Value: Variant;
        FieldValueText: Text;
    begin
        if FieldRef.Class = FieldClass::FlowField then
            RecordRef.SetAutoCalcFields(FieldRef.Number);

        Value := FieldRef.Value;

        case FieldRef.Type of
            FieldType::Date:
                begin
                    if Value then
                        FieldValueText := Format(Value, 0, '<Day,2>.<Month,2>.<Year4>')
                    else
                        FieldValueText := '          ';
                end;
            FieldType::Decimal:
                FieldValueText := Format(Value, 0, '<Precision,2:2><Standard Format,0>');
            FieldType::Option:
                FieldValueText := Format(Value);
            FieldType::Boolean:
                if Value then
                    FieldValueText := 'Yes'
                else
                    FieldValueText := 'No';
            else
                FieldValueText := Format(Value);
        end;
        IF FieldRef.Type IN [FieldType::Boolean, FieldType::Code, FieldType::Option, FieldType::Text] THEN
            FieldValueText := STRSUBSTNO(ValueWithQuotesMsg, ConvertStringText(FieldValueText));

        exit(FieldValueText);
    end;

    local procedure PrepareLogtoTextContent(): Text
    var
        ContentBuilder: TextBuilder;
        Message: Text;
        i: Integer;
        NoOfEmptyTables: Integer;
        NoOfDefinedTables: Integer;
    begin
        NoOfDefinedTables := 0;
        NoOfEmptyTables := 0;

        ContentBuilder.AppendLine(Format(StartDate) + ' to ' + Format(CalcEndDate(EndDate)) + '.');
        ContentBuilder.AppendLine(Format(Today));
        ContentBuilder.AppendLine(PackageCode + ';' + PackageCode);
        for i := 1 to 17 do begin
            ContentBuilder.AppendLine(STRSUBSTNO(LogEntryMsg, TableName[i], FileCount[i], ExportFileName[i]));
            if FileCount[i] = 0 then begin
                NoOfEmptyTables += 1;
            end
            else begin
                NoOfDefinedTables += 1;
            end;
        end;
        ContentBuilder.AppendLine(STRSUBSTNO(NoOfDefinedTablesMsg, NoOfDefinedTables));
        ContentBuilder.AppendLine(STRSUBSTNO(NoOfEmptyTablesMsg, NoOfEmptyTables));
        ContentBuilder.AppendLine(STRSUBSTNO(DurationMsg, Format(CurrentDateTime - StartTime)));

        exit(ContentBuilder.ToText());
    end;


    procedure ExportXML()
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        InStr: InStream;
        FileName: Text;
        Content: Text;
        XMLBuilder: TextBuilder;
        XMLDoc: XmlDocument;
    begin

        CreateXML(Content);
        FileName := 'index.xml';
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Content);
        TempBlob.CreateInStream(InStr);
        datacompresion.AddEntry(InStr, FileName);
    end;

    local procedure GetDelimiterSymbols(var Symbol: array[2] of Text[1])
    var
        DecimalSymbol: Decimal;
    begin
        DecimalSymbol := 1 / 10;
        IF STRPOS(FORMAT(DecimalSymbol, 0, 1), ',') > 0 THEN BEGIN
            Symbol[1] := ',';
            Symbol[2] := '.';
        END ELSE BEGIN
            Symbol[1] := '.';
            Symbol[2] := ',';
        END;
    end;

    local procedure ConvertString(String: Text) NewString: Text
    var
        StrLength: Integer;
        i: Integer;
    begin
        StrLength := STRLEN(String);
        FOR i := 1 TO StrLength DO
            IF String[i] IN ['Ä', 'ä', 'Ö', 'ö', 'Ü', 'ü', 'ß'] THEN
                NewString := NewString + ConvertSpecialChars(String[i])
            ELSE
                NewString := NewString + FORMAT(String[i]);
    end;

    local procedure ConvertSpecialChars(Char: Char) Text: Text[2]
    begin
        CASE Char OF
            'Ä':
                Text := 'Ae';
            'ä':
                Text := 'ae';
            'Ö':
                Text := 'Oe';
            'ö':
                Text := 'oe';
            'Ü':
                Text := 'Ue';
            'ü':
                Text := 'ue';
            'ß':
                Text := 'ss';
        END;
        EXIT(Text);
    end;

    local procedure CreateXML(var XmlData: Text)
    var
        XmlDoc: XmlDocument;
        Declaration: XmlDeclaration;
        Root: XmlElement;
        Child: XmlElement;
        SecondRoot: XmlElement;
        TableRoot: XmlElement;
        ValidityRoot: XmlElement;
        RangeRoot: XmlElement;
        VariableLengthRoot: XmlElement;
        DOCTYPE: XmlDocumentType;
        XmlWriteOptions: XmlWriteOptions;
        Symbol: array[2] of Text[1];
        CompanyInfo: Record "Company Information";
        ConfigPackage: Record "Config. Package";
        ConfigPackageField: Record "Config. Package Field";
        ConfigPackageTable: Record "Config. Package Table";
        TempKeyConfigPackageField: Record "Config. Package Field" temporary;
        TempConfigPackageField: Record "Config. Package Field" temporary;
        ConfigPackageFilter: Record "Config. Package Filter";
        TableMetadata: Record "Table Metadata";
    begin
        CompanyInfo.Get();
        GLSetup.Get();
        ConfigPackage.Get(PackageCode);
        XmlDoc := XmlDocument.Create();

        Declaration := XmlDeclaration.Create('1.0', 'utf-8', '');
        XmlDoc.SetDeclaration(Declaration);
        DOCTYPE := XmlDocumentType.Create('DataSetSYSTEM', '', ConfigPackage."DTD File Name", '');
        XmlDoc.Add(DOCTYPE);
        Root := XmlElement.Create('DataSet');

        Child := XmlElement.Create('Version');

        Root.Add(Child);
        SecondRoot := XmlElement.Create('DataSupplier');
        Child := XmlElement.Create('Name');
        Child.Add(ConvertString(COMPANYNAME));
        SecondRoot.Add(Child);
        Child := XmlElement.Create('Location');
        Child.Add(ConvertString(CompanyInfo.Address) + ' ' + ConvertString(CompanyInfo."Address 2") + ' ' + ConvertString(CompanyInfo."Post Code") + ' ' + ConvertString(CompanyInfo.City));
        SecondRoot.Add(Child);
        Child := XmlElement.Create('Comment');
        Child.Add('GDPdU Export Definition');
        SecondRoot.Add(Child);
        Root.Add(SecondRoot);

        SecondRoot := XmlElement.Create('Media');
        Child := XmlElement.Create('Name');
        Child.add('GDPDU');
        SecondRoot.Add(Child);

        ConfigPackageTable.Reset();
        ConfigPackageTable.SetRange("Package Code", PackageCode);
        ConfigPackageTable.SetCurrentKey("Processing Order");
        if ConfigPackageTable.FindFirst() then begin
            repeat
                TableRoot := XmlElement.Create('Table');
                Child := XmlElement.Create('URL');
                Child.add(ConvertString(ConfigPackageTable."Export Field Name"));
                TableRoot.add(Child);
                TableMetadata.Get(ConfigPackageTable."Table ID");
                Child := XmlElement.Create('Name');
                Child.add(CustomClean(ConvertString(TableMetadata.Name)));
                TableRoot.add(Child);
                Child := XmlElement.Create('Description');
                Child.add(ConvertString(TableMetadata.Caption));
                TableRoot.add(Child);

                ConfigPackageFilter.Reset();
                ConfigPackageFilter.SetRange("Package Code", PackageCode);
                ConfigPackageFilter.SetRange("Table ID", ConfigPackageTable."Table ID");
                if ConfigPackageFilter.FindFirst() then begin
                    ValidityRoot := XmlElement.Create('Validity');
                    RangeRoot := XmlElement.Create('Range');
                    Child := XmlElement.Create('From');
                    Child.add(FORMAT(StartDate, 0, '<Day,2>.<Month,2>.<Year4>'));
                    RangeRoot.add(Child);
                    Child := XmlElement.Create('To');
                    Child.add(FORMAT(EndDate, 0, '<Day,2>.<Month,2>.<Year4>'));
                    RangeRoot.add(Child);

                    ValidityRoot.add(RangeRoot);
                    TableRoot.add(ValidityRoot);
                end;

                GetDelimiterSymbols(Symbol);
                Child := XmlElement.Create('DecimalSymbol');
                Child.add(Symbol[1]);
                TableRoot.add(Child);
                Child := XmlElement.Create('DigitGroupingSymbol');
                Child.add(Symbol[2]);
                TableRoot.add(Child);

                ConfigPackageField.Reset();
                ConfigPackageField.SetRange("Package Code", PackageCode);
                ConfigPackageField.SetRange("Table ID", ConfigPackageTable."Table ID");
                ConfigPackageField.SetRange("Include Field", true);
                if ConfigPackageField.FindFirst() then begin
                    VariableLengthRoot := XmlElement.Create('VariableLength');
                    CollectFieldNumbers(ConfigPackageField, TempKeyConfigPackageField, TempConfigPackageField);

                    DeleteKeyToConfigPackage(TempKeyConfigPackageField, PackageCode, ConfigPackageTable."Table ID");
                    AddFieldsToConfigPackage(TempConfigPackageField, PackageCode, ConfigPackageTable."Table ID");

                    AddFieldsData(ConfigPackageField, TempKeyConfigPackageField, 'VariablePrimaryKey', VariableLengthRoot);
                    AddFieldsData(ConfigPackageField, TempConfigPackageField, 'VariableColumn', VariableLengthRoot);

                    TableRoot.add(VariableLengthRoot);
                end;

                SecondRoot.Add(TableRoot);
            until ConfigPackageTable.Next() = 0;
        end;

        Root.Add(SecondRoot);
        XmlDoc.Add(Root);

        //XmlWriteOptions.PreserveWhitespace(true);
        //XmlDoc.WriteTo(XmlData, XmlWriteOptions::Indented);
        XmlDoc.WriteTo(XmlWriteOptions, XmlData);
    end;

    local procedure AddFieldsData(var DataExportRecordField: Record "Config. Package Field"; var TempDataExportRecordField: Record "Config. Package Field" temporary; FieldTagName: Text; var VariableLengthRoot: XmlElement)
    var
        DataExportRecordField2: Record "Config. Package Field" temporary;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        Root: XmlElement;
        Child: XmlElement;
        NumericRoot: XmlElement;
        FieldName: Text;
    begin
        RecRef.OPEN(TempDataExportRecordField."Table ID");
        IF TempDataExportRecordField.FINDSET THEN
            REPEAT
                FieldRef := RecRef.FIELD(TempDataExportRecordField."Field ID");
                Root := XmlElement.Create(FieldTagName);
                Child := XmlElement.Create('Name');
                Child.add(ConvertString(TempDataExportRecordField."Export Field Name"));
                Root.Add(Child);
                Child := XmlElement.Create('Description');
                FieldName := TempDataExportRecordField."Field Name";
                Child.add(ConvertString(FieldName));
                Root.Add(Child);
                case FORMAT(FieldRef.TYPE) OF
                    'Integer', 'BigInteger':
                        begin
                            Child := XmlElement.Create('Numeric');
                            Root.Add(Child);
                        end;
                    'Decimal':
                        begin
                            NumericRoot := XmlElement.Create('Numeric');
                            Child := XmlElement.Create('Accuracy');
                            Child.Add(COPYSTR(GLSetup."Amount Decimal Places", STRLEN(GLSetup."Amount Decimal Places")));
                            NumericRoot.Add(Child);
                            Root.Add(NumericRoot);
                        end;
                    'Date':
                        begin
                            Child := XmlElement.Create('Date');
                            Root.Add(Child)
                        end;
                    ELSE begin
                        Child := XmlElement.Create('AlphaNumeric');
                        Root.Add(Child)
                    end;
                end;

                VariableLengthRoot.Add(Root);
            UNTIL TempDataExportRecordField.NEXT = 0;
        RecRef.CLOSE;
    end;

    local procedure CollectField(var ConfigPackageField: Record "Config. Package Field"; var TempConfigPackageField: Record "Config. Package Field" temporary)
    var
        RecRef: RecordRef;
    begin
        TempConfigPackageField.DELETEALL;
        IF ConfigPackageField.FINDSET THEN BEGIN
            RecRef.OPEN(ConfigPackageField."Table ID");
            REPEAT
                AddFieldNoToBuffer(TempConfigPackageField, ConfigPackageField."Package Code", ConfigPackageField."Table ID", ConfigPackageField."Field ID", ConfigPackageField."Field Name", ConfigPackageField."Processing Order", ConfigPackageField."Export Field Name");
            UNTIL ConfigPackageField.NEXT = 0;
            RecRef.CLOSE;
        END;
    end;

    local procedure CollectFieldNumbers(var ConfigPackageField: Record "Config. Package Field"; var TempKeyConfigPackageField: Record "Config. Package Field" temporary; var TempConfigPackageField: Record "Config. Package Field" temporary)
    var
        RecRef: RecordRef;
        KeyRef: KeyRef;
    begin
        TempKeyConfigPackageField.DELETEALL;
        TempConfigPackageField.DELETEALL;
        IF ConfigPackageField.FINDSET THEN BEGIN
            RecRef.OPEN(ConfigPackageField."Table ID");
            KeyRef := RecRef.KEYINDEX(1);
            REPEAT
                IF IsFieldKeyDynamic(ConfigPackageField."Field ID", KeyRef) THEN
                    AddFieldNoToBuffer(TempKeyConfigPackageField, ConfigPackageField."Package Code", ConfigPackageField."Table ID", ConfigPackageField."Field ID", ConfigPackageField."Field Name", ConfigPackageField."Processing Order", ConfigPackageField."Export Field Name")
                ELSE
                    AddFieldNoToBuffer(TempConfigPackageField, ConfigPackageField."Package Code", ConfigPackageField."Table ID", ConfigPackageField."Field ID", ConfigPackageField."Field Name", ConfigPackageField."Processing Order", ConfigPackageField."Export Field Name");
            UNTIL ConfigPackageField.NEXT = 0;
            RecRef.CLOSE;
        END;
    end;

    procedure IsFieldKeyDynamic(FieldId: Integer; var KeyRef: KeyRef): Boolean
    var

        FieldRef: FieldRef;
        i, j : Integer;
    begin
        for j := 1 to KeyRef.FieldCount do begin
            FieldRef := KeyRef.FieldIndex(j);
            if FieldRef.Number = FieldId then
                exit(true);
        end;
        exit(false);
    end;

    local procedure AddFieldNoToBuffer(var TempConfigPackageField: Record "Config. Package Field" temporary; PackageCode: Code[20]; TableID: Integer; FieldID: Integer; FieldName: Text; ProcessingOrder: Integer; ExportFieldName: Text)
    begin
        TempConfigPackageField.INIT;
        TempConfigPackageField."Package Code" := PackageCode;
        TempConfigPackageField."Table ID" := TableID;
        TempConfigPackageField."Field ID" := FieldID;
        TempConfigPackageField."Field Name" := FieldName;
        TempConfigPackageField."Processing Order" := ProcessingOrder;
        TempConfigPackageField."Export Field Name" := ExportFieldName;
        TempConfigPackageField.INSERT;
    end;

    procedure AddFieldsToConfigPackage(var TempConfigPackageField: Record "Config. Package Field" temporary; PackageCode: Code[20]; TableID: Integer)
    begin
        case TableID of
            15:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 31) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 31, 'Balance at Date', 31, 'SaldobisDatum');

                    if not TempConfigPackageField.Get(PackageCode, TableID, 32) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 32, 'Net Change', 32, 'Bewegung');
                end;
            18:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 61) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 61, 'Net Change (LCY)', 61, 'BewegungMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 99) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 99, 'Debit Amount (LCY)', 99, 'SollbetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 100) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 100, 'Credit Amount (LCY)', 100, 'HabenbetragMW');
                end;
            21:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 16) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 16, 'Remaining Amt. (LCY)', 16, 'RestbetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 17) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 17, 'Amount (LCY)', 17, 'BetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 60) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 60, 'Debit Amount (LCY)', 60, 'SollbetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 61) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 61, 'Credit Amount (LCY)', 61, 'HabenbetragMW');
                end;
            23:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 61) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 61, 'Net Change (LCY)', 61, 'BewegungMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 99) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 99, 'Debit Amount (LCY)', 99, 'SollbetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 100) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 100, 'Credit Amount (LCY)', 100, 'HabenbetragMW');
                end;
            25:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 16) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 16, 'Remaining Amt. (LCY)', 16, 'RestbetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 17) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 17, 'Amount (LCY)', 17, 'BetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 60) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 60, 'Debit Amount (LCY)', 60, 'SollbetragMW');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 61) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 61, 'Credit Amount (LCY)', 61, 'HabenbetragMW');
                end;
            27:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 70) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 70, 'Net Change', 70, 'Bewegung');
                end;
            32:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 5816) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 5816, 'Sales Amount (Actual)', 5816, 'Verkaufsbetragtatsächl');
                end;
            112:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 60) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 60, 'Amount', 27, 'Betrag');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 61) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 61, 'Amount Including VAT', 28, 'BetraginklMwSt');
                end;
            114:
                begin
                    if not TempConfigPackageField.Get(PackageCode, TableID, 60) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 60, 'Amount', 26, 'Betrag');
                    if not TempConfigPackageField.Get(PackageCode, TableID, 61) then
                        AddFieldNoToBuffer(TempConfigPackageField, PackageCode, TableID, 61, 'Amount Including VAT', 27, 'BetraginklMwSt');
                end;
        end;
    end;

    procedure DeleteKeyToConfigPackage(var TempKeyConfigPackageField: Record "Config. Package Field" temporary; PackageCode: Code[20]; TableID: Integer)
    begin
        case TableID of
            32:
                begin
                    if TempKeyConfigPackageField.Get(PackageCode, TableID, 1) then
                        TempKeyConfigPackageField.Delete();
                end;
            45:
                begin
                    if TempKeyConfigPackageField.Get(PackageCode, TableID, 1) then
                        TempKeyConfigPackageField.Delete();
                end;
            98:
                begin
                    if TempKeyConfigPackageField.Get(PackageCode, TableID, 1) then
                        TempKeyConfigPackageField.Delete();
                end;
            254:
                begin
                    if TempKeyConfigPackageField.Get(PackageCode, TableID, 1) then
                        TempKeyConfigPackageField.Delete();
                end;
        end;
    end;

    procedure ExportDTDFile()
    var
        InStr: InStream;
        OutStr: OutStream;
        TempBlob: Codeunit "Temp Blob";
        ConfigPackage: Record "Config. Package";
    begin
        ConfigPackage.Get(PackageCode);
        Clear(ConfigPackage."DTD File");
        ConfigPackage."DTD File".CreateInStream(InStr);
        TempBlob.CreateOutStream(OutStr, TextEncoding::UTF8);
        GetBlobFormDTDFile(ConfigPackage, TempBlob);
        TempBlob.CreateInStream(InStr);
        datacompresion.AddEntry(InStr, ConfigPackage."DTD File Name");
    end;

    procedure GetBlobFormDTDFile(Record: Record "Config. Package"; var TempBlob: Codeunit "Temp Blob")
    begin
        if not TempBlob.HasValue() then
            TempBlob.FromRecord(Record, Record.FieldNo("DTD File"));
    end;

    local procedure FillCharsToDelete()
    var
        S: Text;
        i: Integer;
    begin
        NewLine[1] := 13;
        NewLine[2] := 10;

        CharsToDelete := NewLine;
        CharsToDelete[3] := 34;
        CharsToDelete[4] := 39;
        FOR i := 128 TO 255 DO BEGIN
            S[1] := i;
            IF NOT (S IN ['Ä', 'ä', 'Ö', 'ö', 'Ü', 'ü', 'ß']) THEN
                CharsToDelete := CharsToDelete + S;
        END;
    end;

    local procedure ConvertStringText(String: Text) NewString: Text
    begin
        NewString := DELCHR(String, '=', CharsToDelete);
    end;

    local procedure CalcEndDate(Date: Date): Date
    begin
        IF ShowExpected THEN
            EXIT(CLOSINGDATE(Date));
        EXIT(Date);
    end;

    local procedure CustomClean(InputText: Text): Text
    begin
        InputText := ConvertStr(InputText, '.', ' ');
        InputText := ConvertStr(InputText, '/', ' ');
        InputText := DelChr(InputText, '=', ' ');
        exit(InputText);
    end;

}

