report 50056 "Inventory Availability List"
{
    // HG10.00.02 NJ 01/06/2017 - Hagirawa US Upgrade
    // CS013 KenChen 2021/4/30 - Enhancement of Inventory Availability List
    // CS092 FDD R025 Bobby.ji 2025/8/1 - Upgrade to the BC version
    DefaultLayout = RDLC;
    RDLCLayout = './RDLC/InventoryAvailabilityList.rdlc';

    Caption = 'Inventory Availability List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Item; Item)
        {
            DataItemTableView = WHERE(Type = CONST(Inventory));
            RequestFilterFields = "No.", Blocked, "Location Filter", "Variant Filter", "Search Description", "Assembly BOM", "Inventory Posting Group", "Vendor No.";
            column(CompanyName; COMPANYNAME)
            {
            }
            column(TblCptItemFilter; TABLECAPTION + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(POShowStar; POShowStar)
            {
            }
            column(ExpectedReceiptDateFlag1; ExpectedReceiptDateFlag[1])
            {
            }
            column(ExpectedReceiptDateFlag2; ExpectedReceiptDateFlag[2])
            {
            }
            column(ExpectedReceiptDateFlag3; ExpectedReceiptDateFlag[3])
            {
            }
            column(ExpectedReceiptDateFlag4; ExpectedReceiptDateFlag[4])
            {
            }
            column(ExpectedReceiptDateFlag5; ExpectedReceiptDateFlag[5])
            {
            }
            column(ExpectedReceiptDateFlag6; ExpectedReceiptDateFlag[6])
            {
            }
            column(ExpectedReceiptDateFlag7; ExpectedReceiptDateFlag[7])
            {
            }
            column(ExpectedReceiptDateFlag8; ExpectedReceiptDateFlag[8])
            {
            }
            column(ExpectedReceiptDateFlag9; ExpectedReceiptDateFlag[9])
            {
            }
            column(ExpectedReceiptDateFlag10; ExpectedReceiptDateFlag[10])
            {
            }
            column(ExpectedReceiptDateFlag11; ExpectedReceiptDateFlag[11])
            {
            }
            column(ExpectedReceiptDateFlag12; ExpectedReceiptDateFlag[12])
            {
            }
            column(ExpectedReceiptDateFlag13; ExpectedReceiptDateFlag[13])
            {
            }
            column(ExpectedReceiptDateFlag14; ExpectedReceiptDateFlag[14])
            {
            }
            column(ExpectedReceiptDateFlag15; ExpectedReceiptDateFlag[15])
            {
            }
            column(ExpectedReceiptDateFlag16; ExpectedReceiptDateFlag[16])
            {
            }
            column(ExpectedReceiptDateFlag17; ExpectedReceiptDateFlag[17])
            {
            }
            column(ExpectedReceiptDateFlag18; ExpectedReceiptDateFlag[18])
            {
            }
            column(ExpectedReceiptDateFlag19; ExpectedReceiptDateFlag[19])
            {
            }
            column(ExpectedReceiptDateFlag20; ExpectedReceiptDateFlag[20])
            {
            }
            column(ExpectedReceiptDateFlag21; ExpectedReceiptDateFlag[21])
            {
            }
            column(ExpectedReceiptDateFlag22; ExpectedReceiptDateFlag[22])
            {
            }
            column(ExpectedReceiptDateFlag23; ExpectedReceiptDateFlag[23])
            {
            }
            column(ExpectedReceiptDateFlag24; ExpectedReceiptDateFlag[24])
            {
            }
            column(ExpectedReceiptDateFlag25; ExpectedReceiptDateFlag[25])
            {
            }
            column(ExpectedReceiptDateFlag26; ExpectedReceiptDateFlag[26])
            {
            }
            column(ExpectedReceiptDateFlag27; ExpectedReceiptDateFlag[27])
            {
            }
            column(ExpectedReceiptDateFlag28; ExpectedReceiptDateFlag[28])
            {
            }
            column(ExpectedReceiptDateFlag29; ExpectedReceiptDateFlag[29])
            {
            }
            column(ExpectedReceiptDateFlag30; ExpectedReceiptDateFlag[30])
            {
            }
            column(ExpectedReceiptDateFlag31; ExpectedReceiptDateFlag[31])
            {
            }
            column(ExpectedReceiptDateFlag32; ExpectedReceiptDateFlag[32])
            {
            }
            column(ExpectedReceiptDateFlag33; ExpectedReceiptDateFlag[33])
            {
            }
            column(ExpectedReceiptDateFlag34; ExpectedReceiptDateFlag[34])
            {
            }
            column(ExpectedReceiptDateFlag35; ExpectedReceiptDateFlag[35])
            {
            }
            column(ExpectedReceiptDateFlag36; ExpectedReceiptDateFlag[36])
            {
            }
            column(ExpectedReceiptDateFlag37; ExpectedReceiptDateFlag[37])
            {
            }
            column(ExpectedReceiptDateFlag38; ExpectedReceiptDateFlag[38])
            {
            }
            column(ExpectedReceiptDateFlag39; ExpectedReceiptDateFlag[39])
            {
            }
            column(ExpectedReceiptDateFlag40; ExpectedReceiptDateFlag[40])
            {
            }
            column(ExpectedReceiptDateFlag41; ExpectedReceiptDateFlag[41])
            {
            }
            column(ExpectedReceiptDateFlag42; ExpectedReceiptDateFlag[42])
            {
            }
            column(ExpectedReceiptDateFlag43; ExpectedReceiptDateFlag[43])
            {
            }
            column(ExpectedReceiptDateFlag44; ExpectedReceiptDateFlag[44])
            {
            }
            column(ExpectedReceiptDateFlag45; ExpectedReceiptDateFlag[45])
            {
            }
            column(ExpectedReceiptDateFlag46; ExpectedReceiptDateFlag[46])
            {
            }
            column(ExpectedReceiptDateFlag47; ExpectedReceiptDateFlag[47])
            {
            }
            column(ExpectedReceiptDateFlag48; ExpectedReceiptDateFlag[48])
            {
            }
            column(ExpectedReceiptDateFlag49; ExpectedReceiptDateFlag[49])
            {
            }
            column(ExpectedReceiptDateFlag50; ExpectedReceiptDateFlag[50])
            {
            }
            column(ExpectedReceiptDateFlag51; ExpectedReceiptDateFlag[51])
            {
            }
            column(ExpectedReceiptDateFlag52; ExpectedReceiptDateFlag[52])
            {
            }
            column(PeriodStartDate2; FORMAT(PeriodStartDate[2]))
            {
            }
            column(PeriodStartDate3; FORMAT(PeriodStartDate[3]))
            {
            }
            column(PeriodStartDate4; FORMAT(PeriodStartDate[4]))
            {
            }
            column(PeriodStartDate5; FORMAT(PeriodStartDate[5]))
            {
            }
            column(PeriodStartDate6; FORMAT(PeriodStartDate[6]))
            {
            }
            column(PeriodStartDate7; FORMAT(PeriodStartDate[7]))
            {
            }
            column(PeriodStartDate8; FORMAT(PeriodStartDate[8]))
            {
            }
            column(PeriodStartDate9; FORMAT(PeriodStartDate[9]))
            {
            }
            column(PeriodStartDate10; FORMAT(PeriodStartDate[10]))
            {
            }
            column(PeriodStartDate11; FORMAT(PeriodStartDate[11]))
            {
            }
            column(PeriodStartDate12; FORMAT(PeriodStartDate[12]))
            {
            }
            column(PeriodStartDate13; FORMAT(PeriodStartDate[13]))
            {
            }
            column(PeriodStartDate14; FORMAT(PeriodStartDate[14]))
            {
            }
            column(PeriodStartDate15; FORMAT(PeriodStartDate[15]))
            {
            }
            column(PeriodStartDate16; FORMAT(PeriodStartDate[16]))
            {
            }
            column(PeriodStartDate17; FORMAT(PeriodStartDate[17]))
            {
            }
            column(PeriodStartDate18; FORMAT(PeriodStartDate[18]))
            {
            }
            column(PeriodStartDate19; FORMAT(PeriodStartDate[19]))
            {
            }
            column(PeriodStartDate20; FORMAT(PeriodStartDate[20]))
            {
            }
            column(PeriodStartDate21; FORMAT(PeriodStartDate[21]))
            {
            }
            column(PeriodStartDate22; FORMAT(PeriodStartDate[22]))
            {
            }
            column(PeriodStartDate23; FORMAT(PeriodStartDate[23]))
            {
            }
            column(PeriodStartDate24; FORMAT(PeriodStartDate[24]))
            {
            }
            column(PeriodStartDate25; FORMAT(PeriodStartDate[25]))
            {
            }
            column(PeriodStartDate26; FORMAT(PeriodStartDate[26]))
            {
            }
            column(PeriodStartDate27; FORMAT(PeriodStartDate[27]))
            {
            }
            column(PeriodStartDate28; FORMAT(PeriodStartDate[28]))
            {
            }
            column(PeriodStartDate29; FORMAT(PeriodStartDate[29]))
            {
            }
            column(PeriodStartDate30; FORMAT(PeriodStartDate[30]))
            {
            }
            column(PeriodStartDate31; FORMAT(PeriodStartDate[31]))
            {
            }
            column(PeriodStartDate32; FORMAT(PeriodStartDate[32]))
            {
            }
            column(PeriodStartDate33; FORMAT(PeriodStartDate[33]))
            {
            }
            column(PeriodStartDate34; FORMAT(PeriodStartDate[34]))
            {
            }
            column(PeriodStartDate35; FORMAT(PeriodStartDate[35]))
            {
            }
            column(PeriodStartDate36; FORMAT(PeriodStartDate[36]))
            {
            }
            column(PeriodStartDate37; FORMAT(PeriodStartDate[37]))
            {
            }
            column(PeriodStartDate38; FORMAT(PeriodStartDate[38]))
            {
            }
            column(PeriodStartDate39; FORMAT(PeriodStartDate[39]))
            {
            }
            column(PeriodStartDate40; FORMAT(PeriodStartDate[40]))
            {
            }
            column(PeriodStartDate41; FORMAT(PeriodStartDate[41]))
            {
            }
            column(PeriodStartDate42; FORMAT(PeriodStartDate[42]))
            {
            }
            column(PeriodStartDate43; FORMAT(PeriodStartDate[43]))
            {
            }
            column(PeriodStartDate44; FORMAT(PeriodStartDate[44]))
            {
            }
            column(PeriodStartDate45; FORMAT(PeriodStartDate[45]))
            {
            }
            column(PeriodStartDate46; FORMAT(PeriodStartDate[46]))
            {
            }
            column(PeriodStartDate47; FORMAT(PeriodStartDate[47]))
            {
            }
            column(PeriodStartDate48; FORMAT(PeriodStartDate[48]))
            {
            }
            column(PeriodStartDate49; FORMAT(PeriodStartDate[49]))
            {
            }
            column(PeriodStartDate50; FORMAT(PeriodStartDate[50]))
            {
            }
            column(PeriodStartDate51; FORMAT(PeriodStartDate[51]))
            {
            }
            column(PeriodEndDate2; FORMAT(PeriodStartDate[3] - 1))
            {
            }
            column(PeriodEndDate3; FORMAT(PeriodStartDate[4] - 1))
            {
            }
            column(PeriodEndDate4; FORMAT(PeriodStartDate[5] - 1))
            {
            }
            column(PeriodEndDate5; FORMAT(PeriodStartDate[6] - 1))
            {
            }
            column(PeriodEndDate6; FORMAT(PeriodStartDate[7] - 1))
            {
            }
            column(PeriodEndDate7; FORMAT(PeriodStartDate[8] - 1))
            {
            }
            column(PeriodEndDate8; FORMAT(PeriodStartDate[9] - 1))
            {
            }
            column(PeriodEndDate9; FORMAT(PeriodStartDate[10] - 1))
            {
            }
            column(PeriodEndDate10; FORMAT(PeriodStartDate[11] - 1))
            {
            }
            column(PeriodEndDate11; FORMAT(PeriodStartDate[12] - 1))
            {
            }
            column(PeriodEndDate12; FORMAT(PeriodStartDate[13] - 1))
            {
            }
            column(PeriodEndDate13; FORMAT(PeriodStartDate[14] - 1))
            {
            }
            column(PeriodEndDate14; FORMAT(PeriodStartDate[15] - 1))
            {
            }
            column(PeriodEndDate15; FORMAT(PeriodStartDate[16] - 1))
            {
            }
            column(PeriodEndDate16; FORMAT(PeriodStartDate[17] - 1))
            {
            }
            column(PeriodEndDate17; FORMAT(PeriodStartDate[18] - 1))
            {
            }
            column(PeriodEndDate18; FORMAT(PeriodStartDate[19] - 1))
            {
            }
            column(PeriodEndDate19; FORMAT(PeriodStartDate[20] - 1))
            {
            }
            column(PeriodEndDate20; FORMAT(PeriodStartDate[21] - 1))
            {
            }
            column(PeriodEndDate21; FORMAT(PeriodStartDate[22] - 1))
            {
            }
            column(PeriodEndDate22; FORMAT(PeriodStartDate[23] - 1))
            {
            }
            column(PeriodEndDate23; FORMAT(PeriodStartDate[24] - 1))
            {
            }
            column(PeriodEndDate24; FORMAT(PeriodStartDate[25] - 1))
            {
            }
            column(PeriodEndDate25; FORMAT(PeriodStartDate[26] - 1))
            {
            }
            column(PeriodEndDate26; FORMAT(PeriodStartDate[27] - 1))
            {
            }
            column(PeriodEndDate27; FORMAT(PeriodStartDate[28] - 1))
            {
            }
            column(PeriodEndDate28; FORMAT(PeriodStartDate[29] - 1))
            {
            }
            column(PeriodEndDate29; FORMAT(PeriodStartDate[30] - 1))
            {
            }
            column(PeriodEndDate30; FORMAT(PeriodStartDate[31] - 1))
            {
            }
            column(PeriodEndDate31; FORMAT(PeriodStartDate[32] - 1))
            {
            }
            column(PeriodEndDate32; FORMAT(PeriodStartDate[33] - 1))
            {
            }
            column(PeriodEndDate33; FORMAT(PeriodStartDate[34] - 1))
            {
            }
            column(PeriodEndDate34; FORMAT(PeriodStartDate[35] - 1))
            {
            }
            column(PeriodEndDate35; FORMAT(PeriodStartDate[36] - 1))
            {
            }
            column(PeriodEndDate36; FORMAT(PeriodStartDate[37] - 1))
            {
            }
            column(PeriodEndDate37; FORMAT(PeriodStartDate[38] - 1))
            {
            }
            column(PeriodEndDate38; FORMAT(PeriodStartDate[39] - 1))
            {
            }
            column(PeriodEndDate39; FORMAT(PeriodStartDate[40] - 1))
            {
            }
            column(PeriodEndDate40; FORMAT(PeriodStartDate[41] - 1))
            {
            }
            column(PeriodEndDate41; FORMAT(PeriodStartDate[42] - 1))
            {
            }
            column(PeriodEndDate42; FORMAT(PeriodStartDate[43] - 1))
            {
            }
            column(PeriodEndDate43; FORMAT(PeriodStartDate[44] - 1))
            {
            }
            column(PeriodEndDate44; FORMAT(PeriodStartDate[45] - 1))
            {
            }
            column(PeriodEndDate45; FORMAT(PeriodStartDate[46] - 1))
            {
            }
            column(PeriodEndDate46; FORMAT(PeriodStartDate[47] - 1))
            {
            }
            column(PeriodEndDate47; FORMAT(PeriodStartDate[48] - 1))
            {
            }
            column(PeriodEndDate48; FORMAT(PeriodStartDate[49] - 1))
            {
            }
            column(PeriodEndDate49; FORMAT(PeriodStartDate[50] - 1))
            {
            }
            column(PeriodEndDate50; FORMAT(PeriodStartDate[51] - 1))
            {
            }
            column(PeriodEndDate51; FORMAT(PeriodStartDate[52] - 1))
            {
            }
            column(UseStockkeepingUnit; UseStockkeepingUnit)
            {
            }
            column(No_Item; "No.")
            {
            }
            column(Description_Item; Description)
            {
            }
            column(VendorNo_Item; "Vendor No.")
            {
            }
            column(VendName; Vend.Name)
            {
            }
            column(VendorItemNo_Item; "Vendor Item No.")
            {
                IncludeCaption = true;
            }
            column(LeadTimeCalc_Item; "Lead Time Calculation")
            {
                IncludeCaption = true;
            }
            column(GrossReq1; GrossReq[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq2; GrossReq[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq3; GrossReq[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq4; GrossReq[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq5; GrossReq[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq6; GrossReq[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq7; GrossReq[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq8; GrossReq[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq9; GrossReq[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq10; GrossReq[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq11; GrossReq[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq12; GrossReq[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq13; GrossReq[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq14; GrossReq[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq15; GrossReq[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq16; GrossReq[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq17; GrossReq[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq18; GrossReq[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq19; GrossReq[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq20; GrossReq[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq21; GrossReq[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq22; GrossReq[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq23; GrossReq[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq24; GrossReq[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq25; GrossReq[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq26; GrossReq[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq27; GrossReq[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq28; GrossReq[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq29; GrossReq[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq30; GrossReq[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq31; GrossReq[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq32; GrossReq[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq33; GrossReq[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq34; GrossReq[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq35; GrossReq[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq36; GrossReq[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq37; GrossReq[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq38; GrossReq[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq39; GrossReq[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq40; GrossReq[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq41; GrossReq[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq42; GrossReq[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq43; GrossReq[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq44; GrossReq[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq45; GrossReq[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq46; GrossReq[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq47; GrossReq[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq48; GrossReq[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq49; GrossReq[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq50; GrossReq[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq51; GrossReq[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossReq52; GrossReq[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt1; SchedReceipt[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt2; SchedReceipt[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt3; SchedReceipt[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt4; SchedReceipt[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt5; SchedReceipt[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt6; SchedReceipt[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt7; SchedReceipt[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt8; SchedReceipt[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt9; SchedReceipt[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt10; SchedReceipt[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt11; SchedReceipt[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt12; SchedReceipt[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt13; SchedReceipt[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt14; SchedReceipt[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt15; SchedReceipt[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt16; SchedReceipt[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt17; SchedReceipt[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt18; SchedReceipt[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt19; SchedReceipt[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt20; SchedReceipt[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt21; SchedReceipt[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt22; SchedReceipt[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt23; SchedReceipt[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt24; SchedReceipt[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt25; SchedReceipt[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt26; SchedReceipt[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt27; SchedReceipt[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt28; SchedReceipt[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt29; SchedReceipt[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt30; SchedReceipt[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt31; SchedReceipt[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt32; SchedReceipt[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt33; SchedReceipt[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt34; SchedReceipt[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt35; SchedReceipt[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt36; SchedReceipt[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt37; SchedReceipt[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt38; SchedReceipt[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt39; SchedReceipt[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt40; SchedReceipt[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt41; SchedReceipt[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt42; SchedReceipt[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt43; SchedReceipt[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt44; SchedReceipt[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt45; SchedReceipt[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt46; SchedReceipt[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt47; SchedReceipt[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt48; SchedReceipt[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt49; SchedReceipt[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt50; SchedReceipt[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt51; SchedReceipt[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(SchedReceipt52; SchedReceipt[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Inventory_Item; Inventory - Hold)
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance1; ProjAvBalance[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance2; ProjAvBalance[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance3; ProjAvBalance[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance4; ProjAvBalance[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance5; ProjAvBalance[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance6; ProjAvBalance[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance7; ProjAvBalance[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance8; ProjAvBalance[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance9; ProjAvBalance[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance10; ProjAvBalance[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance11; ProjAvBalance[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance12; ProjAvBalance[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance13; ProjAvBalance[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance14; ProjAvBalance[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance15; ProjAvBalance[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance16; ProjAvBalance[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance17; ProjAvBalance[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance18; ProjAvBalance[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance19; ProjAvBalance[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance20; ProjAvBalance[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance21; ProjAvBalance[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance22; ProjAvBalance[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance23; ProjAvBalance[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance24; ProjAvBalance[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance25; ProjAvBalance[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance26; ProjAvBalance[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance27; ProjAvBalance[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance28; ProjAvBalance[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance29; ProjAvBalance[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance30; ProjAvBalance[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance31; ProjAvBalance[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance32; ProjAvBalance[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance33; ProjAvBalance[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance34; ProjAvBalance[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance35; ProjAvBalance[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance36; ProjAvBalance[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance37; ProjAvBalance[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance38; ProjAvBalance[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance39; ProjAvBalance[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance40; ProjAvBalance[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance41; ProjAvBalance[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance42; ProjAvBalance[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance43; ProjAvBalance[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance44; ProjAvBalance[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance45; ProjAvBalance[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance46; ProjAvBalance[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance47; ProjAvBalance[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance48; ProjAvBalance[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance49; ProjAvBalance[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance50; ProjAvBalance[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance51; ProjAvBalance[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(ProjAvBalance52; ProjAvBalance[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossRequirement; GrossRequirement)
            {
                DecimalPlaces = 0 : 5;
            }
            column(ScheduledReceipt; ScheduledReceipt)
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlannedReceipt; PlannedReceipt)
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt1; PlanReceipt[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt2; PlanReceipt[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt3; PlanReceipt[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt4; PlanReceipt[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt5; PlanReceipt[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt6; PlanReceipt[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt7; PlanReceipt[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt8; PlanReceipt[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt9; PlanReceipt[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt10; PlanReceipt[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt11; PlanReceipt[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt12; PlanReceipt[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt13; PlanReceipt[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt14; PlanReceipt[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt15; PlanReceipt[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt16; PlanReceipt[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt17; PlanReceipt[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt18; PlanReceipt[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt19; PlanReceipt[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt20; PlanReceipt[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt21; PlanReceipt[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt22; PlanReceipt[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt23; PlanReceipt[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt24; PlanReceipt[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt25; PlanReceipt[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt26; PlanReceipt[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt27; PlanReceipt[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt28; PlanReceipt[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt29; PlanReceipt[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt30; PlanReceipt[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt31; PlanReceipt[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt32; PlanReceipt[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt33; PlanReceipt[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt34; PlanReceipt[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt35; PlanReceipt[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt36; PlanReceipt[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt37; PlanReceipt[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt38; PlanReceipt[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt39; PlanReceipt[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt40; PlanReceipt[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt41; PlanReceipt[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt42; PlanReceipt[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt43; PlanReceipt[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt44; PlanReceipt[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt45; PlanReceipt[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt46; PlanReceipt[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt47; PlanReceipt[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt48; PlanReceipt[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt49; PlanReceipt[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt50; PlanReceipt[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt51; PlanReceipt[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanReceipt52; PlanReceipt[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlannedRelease; PlannedRelease)
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease1; PlanRelease[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease2; PlanRelease[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease3; PlanRelease[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease4; PlanRelease[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease5; PlanRelease[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease6; PlanRelease[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease7; PlanRelease[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease8; PlanRelease[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease9; PlanRelease[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease10; PlanRelease[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease11; PlanRelease[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease12; PlanRelease[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease13; PlanRelease[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease14; PlanRelease[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease15; PlanRelease[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease16; PlanRelease[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease17; PlanRelease[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease18; PlanRelease[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease19; PlanRelease[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease20; PlanRelease[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease21; PlanRelease[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease22; PlanRelease[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease23; PlanRelease[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease24; PlanRelease[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease25; PlanRelease[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease26; PlanRelease[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease27; PlanRelease[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease28; PlanRelease[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease29; PlanRelease[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease30; PlanRelease[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease31; PlanRelease[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease32; PlanRelease[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease33; PlanRelease[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease34; PlanRelease[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease35; PlanRelease[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease36; PlanRelease[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease37; PlanRelease[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease38; PlanRelease[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease39; PlanRelease[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease40; PlanRelease[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease41; PlanRelease[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease42; PlanRelease[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease43; PlanRelease[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease44; PlanRelease[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease45; PlanRelease[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease46; PlanRelease[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease47; PlanRelease[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease48; PlanRelease[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease49; PlanRelease[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease50; PlanRelease[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease51; PlanRelease[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PlanRelease52; PlanRelease[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(InventoryAvailabilityPlanCaption; InventoryAvailabilityPlanCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(GrossReq1Caption; GrossReq1CaptionLbl)
            {
            }
            column(GrossReq8Caption; GrossReq8CaptionLbl)
            {
            }
            column(VendorCaption; VendorCaptionLbl)
            {
            }
            column(GrossRequirementCaption; GrossRequirementCaptionLbl)
            {
            }
            column(ScheduledReceiptCaption; ScheduledReceiptCaptionLbl)
            {
            }
            column(InventoryCaption; InventoryCaptionLbl)
            {
            }
            column(PlannedReceiptCaption; PlannedReceiptCaptionLbl)
            {
            }
            column(PlannedReleasesCaption; PlannedReleasesCaptionLbl)
            {
            }
            column(PartsNo; "Parts No.")
            {
            }
            column(Rank; Rank)
            {
            }
            column(CustItemNo; "Customer Item No.")
            {
            }
            column(GrossPrePO; GrossPrePO)
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO1; PrePO[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO2; PrePO[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO3; PrePO[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO4; PrePO[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO5; PrePO[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO6; PrePO[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO7; PrePO[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO8; PrePO[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO9; PrePO[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO10; PrePO[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO11; PrePO[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO12; PrePO[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO13; PrePO[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO14; PrePO[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO15; PrePO[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO16; PrePO[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO17; PrePO[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO18; PrePO[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO19; PrePO[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO20; PrePO[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO21; PrePO[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO22; PrePO[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO23; PrePO[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO24; PrePO[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO25; PrePO[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO26; PrePO[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO27; PrePO[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO28; PrePO[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO29; PrePO[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO30; PrePO[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO31; PrePO[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO32; PrePO[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO33; PrePO[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO34; PrePO[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO35; PrePO[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO36; PrePO[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO37; PrePO[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO38; PrePO[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO39; PrePO[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO40; PrePO[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO41; PrePO[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO42; PrePO[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO43; PrePO[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO44; PrePO[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO45; PrePO[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO46; PrePO[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO47; PrePO[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO48; PrePO[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO49; PrePO[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO50; PrePO[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO51; PrePO[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PrePO52; PrePO[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossForecast; GrossForecast)
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast1; Forecast[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast2; Forecast[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast3; Forecast[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast4; Forecast[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast5; Forecast[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast6; Forecast[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast7; Forecast[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast8; Forecast[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast9; Forecast[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast10; Forecast[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast11; Forecast[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast12; Forecast[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast13; Forecast[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast14; Forecast[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast15; Forecast[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast16; Forecast[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast17; Forecast[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast18; Forecast[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast19; Forecast[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast20; Forecast[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast21; Forecast[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast22; Forecast[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast23; Forecast[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast24; Forecast[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast25; Forecast[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast26; Forecast[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast27; Forecast[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast28; Forecast[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast29; Forecast[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast30; Forecast[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast31; Forecast[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast32; Forecast[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast33; Forecast[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast34; Forecast[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast35; Forecast[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast36; Forecast[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast37; Forecast[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast38; Forecast[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast39; Forecast[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast40; Forecast[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast41; Forecast[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast42; Forecast[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast43; Forecast[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast44; Forecast[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast45; Forecast[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast46; Forecast[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast47; Forecast[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast48; Forecast[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast49; Forecast[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast50; Forecast[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast51; Forecast[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Forecast52; Forecast[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(GrossShipment; GrossShipment)
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment1; Shipment[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment2; Shipment[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment3; Shipment[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment4; Shipment[4])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment5; Shipment[5])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment6; Shipment[6])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment7; Shipment[7])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment8; Shipment[8])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment9; Shipment[9])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment10; Shipment[10])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment11; Shipment[11])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment12; Shipment[12])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment13; Shipment[13])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment14; Shipment[14])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment15; Shipment[15])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment16; Shipment[16])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment17; Shipment[17])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment18; Shipment[18])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment19; Shipment[19])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment20; Shipment[20])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment21; Shipment[21])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment22; Shipment[22])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment23; Shipment[23])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment24; Shipment[24])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment25; Shipment[25])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment26; Shipment[26])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment27; Shipment[27])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment28; Shipment[28])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment29; Shipment[29])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment30; Shipment[30])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment31; Shipment[31])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment32; Shipment[32])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment33; Shipment[33])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment34; Shipment[34])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment35; Shipment[35])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment36; Shipment[36])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment37; Shipment[37])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment38; Shipment[38])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment39; Shipment[39])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment40; Shipment[40])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment41; Shipment[41])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment42; Shipment[42])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment43; Shipment[43])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment44; Shipment[44])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment45; Shipment[45])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment46; Shipment[46])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment47; Shipment[47])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment48; Shipment[48])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment49; Shipment[49])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment50; Shipment[50])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment51; Shipment[51])
            {
                DecimalPlaces = 0 : 5;
            }
            column(Shipment52; Shipment[52])
            {
                DecimalPlaces = 0 : 5;
            }
            column(PartsNoCaption; PartsNoCaptionLbl)
            {
            }
            column(CustItemNoCaption; CustItemNoCaptionLbl)
            {
            }
            column(SalesOrderCaption; SalesOrderCaptionLbl)
            {
            }
            column(PurchOrderCaption; PurchOrderCaptionLbl)
            {
            }
            column(PrePOCaption; PrePOCaptionLbl)
            {
            }
            column(ForecastCaption; ForecastCaptionLbl)
            {
            }
            column(ShipmentCaption; ShipmentCaptionLbl)
            {
            }
            column(Memo; Memo)
            {
            }
            dataitem("Stockkeeping Unit"; "Stockkeeping Unit")
            {
                DataItemLink = "Item No." = FIELD("No."),
                               "Location Code" = FIELD("Location Filter"),
                               "Variant Code" = FIELD("Variant Filter");
                DataItemTableView = SORTING("Item No.", "Location Code", "Variant Code");
                column(Description1_Item; Item.Description)
                {
                }
                column(No1_Item; Item."No.")
                {
                }
                column(SKUPrintLoop; FORMAT(SKUPrintLoop))
                {
                }
                column(ReplenishSys_SKU; FORMAT("Replenishment System", 0, 2))
                {
                }
                column(VendName1; Vend.Name)
                {
                }
                column(VendorNo_SKU; "Vendor No.")
                {
                }
                column(LeadTimeCalc_SKU; "Lead Time Calculation")
                {
                    IncludeCaption = true;
                }
                column(VendItemNo_SKU; "Vendor Item No.")
                {
                    IncludeCaption = true;
                }
                column(LocationName; Location.Name)
                {
                }
                column(TransFrmCode_SKU; "Transfer-from Code")
                {
                }
                column(ShippingTime; ShippingTime)
                {
                }
                column(Inventory1_Item; Inventory)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(PlannedRelease1; PlannedRelease)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(PlannedReceipt1; PlannedReceipt)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(ScheduledReceipt1; ScheduledReceipt)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(GrossReq139; GrossRequirement)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(LocCode_SKU; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(VariantCode_SKU; "Variant Code")
                {
                    IncludeCaption = true;
                }
                column(LocationCaption; LocationCaptionLbl)
                {
                }
                column(ShippingTimeCaption; ShippingTimeCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SKUPrintLoop := SKUPrintLoop + 1;

                    IF "Replenishment System" = "Replenishment System"::Purchase THEN BEGIN
                        IF NOT Vend.GET("Vendor No.") THEN
                            Vend.INIT;
                    END ELSE
                        IF NOT TransferRoute.GET("Transfer-from Code", "Location Code") THEN BEGIN
                            IF NOT Location.GET("Transfer-from Code") THEN
                                Location.INIT;
                        END ELSE BEGIN
                            IF ShippingAgentServices.GET(
                                 TransferRoute."Shipping Agent Code", TransferRoute."Shipping Agent Service Code")
                            THEN
                                ShippingTime := ShippingAgentServices."Shipping Time";
                        END;

                    CALCFIELDS(Inventory);

                    Print := Inventory <> 0;
                    // Yuka 200601124 Added Qty on Purch Quote, Qty on Sales Quote, Sales (Qty.)

                    FOR i := 1 TO 52 DO BEGIN //CS013
                        SETRANGE("Date Filter", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                        CALCFIELDS(
                          "Qty. on Purch. Order",
                          "Qty. on Sales Order",
                          "Qty. on Purch. Quote",
                          "Qty. on Sales Quote",
                          //"Sales (Qty.)",
                          "Scheduled Receipt (Qty.)",
                          "Scheduled Need (Qty.)",
                          "Planned Order Receipt (Qty.)",
                          "FP Order Receipt (Qty.)",
                          "Rel. Order Receipt (Qty.)",
                          "Planned Order Release (Qty.)",
                          "Purch. Req. Receipt (Qty.)",
                          "Purch. Req. Release (Qty.)");

                        GrossReq[i] :=
                            "Qty. on Sales Order";
                        //    "Qty. on Sales Order" +
                        //    "Scheduled Need (Qty.)";
                        PlanReceipt[i] :=
                          "Planned Order Receipt (Qty.)" +
                          "Purch. Req. Receipt (Qty.)";
                        SchedReceipt[i] :=
                            "Qty. on Purch. Order";
                        //    "FP Order Receipt (Qty.)" +
                        //    "Rel. Order Receipt (Qty.)" +
                        //    "Qty. on Purch. Order";
                        PlanRelease[i] :=
                          "Planned Order Release (Qty.)" +
                          "Purch. Req. Release (Qty.)";
                        // Yuka add PrePO and Forecast
                        PrePO[i] :=
                          "Qty. on Purch. Quote";
                        Forecast[i] :=
                          "Qty. on Sales Quote";
                        //  Shipment[i] :=
                        //    "Sales (Qty.)";

                        //  IF (GrossReq[i] <> 0)  OR (PlanReceipt[i] <> 0) OR (SchedReceipt[i] <> 0) OR (PlanRelease[i] <> 0) THEN
                        IF (GrossReq[i] <> 0) OR (SchedReceipt[i] <> 0) OR (PrePO[i] <> 0) OR (Forecast[i] <> 0) THEN
                            Print := TRUE;
                        IF i = 1 THEN
                            ProjAvBalance[1] :=
                              Inventory -
                              //      GrossReq[1] + SchedReceipt[1] + PlanReceipt[1]
                              (GrossReq[i] + Forecast[i]) + SchedReceipt[i] + PrePO[i]
                        ELSE
                            ProjAvBalance[i] :=
                              ProjAvBalance[i - 1] -
                              //      GrossReq[i] + SchedReceipt[i] + PlanReceipt[i];
                              (GrossReq[i] + Forecast[i]) + SchedReceipt[i] + PrePO[i];
                    END;

                    IF NOT Print THEN
                        CurrReport.SKIP;
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT UseStockkeepingUnit THEN
                        CurrReport.BREAK;

                    SKUPrintLoop := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(ExpectedReceiptDateFlag); //CS013
                CLEAR(POShowStar);  //CS013
                IF NOT UseStockkeepingUnit THEN BEGIN
                    IF NOT Vend.GET("Vendor No.") THEN
                        Vend.INIT;
                    CALCFIELDS("Expected Receipt Date Flag");
                    CALCFIELDS(Inventory, Hold);
                    Print := (Inventory - Hold) <> 0;
                    // Yuka 200601124 Added Qty on Purch Quote, Qty on Sales Quote, Sales (Qty.)
                    FOR i := 1 TO 52 DO BEGIN //CS013
                        SETRANGE("Date Filter", PeriodStartDate[i], PeriodStartDate[i + 1] - 1);
                        CALCFIELDS(
                          // sh 20100523 Change Qty on PO based on Request Receipt Date instead of Expected
                          //    "Qty. on Purch. Order",
                          //N005
                          //"Qty. on P. O. (Req Rec Date)",
                          "Qty. on P. O. (Approved)",
                          //N005
                          //sh End
                          //N005
                          //"Qty. on Sales Order",
                          "Qty. on S. O. (Approved)",
                          //N005
                          "Qty. on Purch. Quote",
                          "Qty. on Sales Quote",
                          "Sales (Qty.)",
                          "Scheduled Receipt (Qty.)",
                          "Scheduled Need (Qty.)",
                          "Planning Issues (Qty.)",
                          "Planning Receipt (Qty.)",
                          "Planned Order Receipt (Qty.)",
                          "FP Order Receipt (Qty.)",
                          "Rel. Order Receipt (Qty.)",
                          "Planning Release (Qty.)",
                          "Planned Order Release (Qty.)",
                          "Expected Receipt Date Flag");  //CS013

                        GrossReq[i] :=
                            //N005
                            //"Qty. on Sales Order";
                            "Qty. on S. O. (Approved)";
                        //N005
                        //      "Qty. on Sales Order" +
                        //      "Scheduled Need (Qty.)" +
                        //      "Planning Issues (Qty.)";
                        PlanReceipt[i] :=
                          "Planning Receipt (Qty.)" +
                          "Planned Order Receipt (Qty.)";
                        SchedReceipt[i] :=
                            //SH    "Qty. on Purch. Order";
                            //N005
                            //"Qty. on P. O. (Req Rec Date)";
                            "Qty. on P. O. (Approved)";
                        //N005
                        //      "FP Order Receipt (Qty.)" +
                        //      "Rel. Order Receipt (Qty.)" +
                        //      "Qty. on Purch. Order";
                        //CS013 Start
                        IF "Expected Receipt Date Flag" THEN
                            ExpectedReceiptDateFlag[i] := 1
                        ELSE
                            ExpectedReceiptDateFlag[i] := 0;
                        IF (i > 1) AND (i < 52) AND "Expected Receipt Date Flag" THEN
                            POShowStar := TRUE;
                        //CS013 End
                        PlanRelease[i] :=
                          "Planning Release (Qty.)" +
                          "Planned Order Release (Qty.)";
                        // Yuka add PrePO and Forecast
                        PrePO[i] :=
                          "Qty. on Purch. Quote";
                        Forecast[i] :=
                          "Qty. on Sales Quote";
                        Shipment[i] :=
                          "Sales (Qty.)";

                        //    IF (GrossReq[i] <> 0)  OR (PlanReceipt[i] <> 0) OR (SchedReceipt[i] <> 0) OR (PlanRelease[i] <> 0) THEN
                        IF (GrossReq[i] <> 0) OR (SchedReceipt[i] <> 0) OR (PrePO[i] <> 0) OR (Forecast[i] <> 0) THEN
                            Print := TRUE;
                        IF i = 1 THEN
                            ProjAvBalance[1] :=
                              Inventory - Hold -
                              //        GrossReq[1] + SchedReceipt[1] + PlanReceipt[1]
                              (GrossReq[i] + Forecast[i]) + SchedReceipt[i] + PrePO[i]
                        ELSE
                            ProjAvBalance[i] :=
                              ProjAvBalance[i - 1] -
                              //        GrossReq[i] + SchedReceipt[i] + PlanReceipt[i];
                              (GrossReq[i] + Forecast[i]) + SchedReceipt[i] + PrePO[i];
                    END;

                    IF NOT Print THEN
                        CurrReport.SKIP;
                END;
            end;
        }
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
                    field(StartingDate; PeriodStartDate[2])
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Date';
                        NotBlank = true;
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        ApplicationArea = All;
                        Caption = 'Period Length';
                    }
                    field(UseStockkeepUnit; UseStockkeepingUnit)
                    {
                        ApplicationArea = All;
                        Caption = 'Use Stockkeeping Unit';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF FORMAT(PeriodLength) = '' THEN
                EVALUATE(PeriodLength, '<1W>');
            IF PeriodStartDate[2] = 0D THEN
                PeriodStartDate[2] := WORKDATE;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GETFILTERS;
        FOR i := 2 TO 51 DO //CS013
            PeriodStartDate[i + 1] := CALCDATE(PeriodLength, PeriodStartDate[i]);
        PeriodStartDate[53] := 99991231D;
    end;

    var
        Vend: Record Vendor;
        Location: Record Location;
        TransferRoute: Record "Transfer Route";
        ShippingAgentServices: Record "Shipping Agent Services";
        ItemFilter: Text;
        SchedReceipt: array[52] of Decimal;
        PlanReceipt: array[52] of Decimal;
        PlanRelease: array[52] of Decimal;
        PeriodStartDate: array[53] of Date;
        ProjAvBalance: array[52] of Decimal;
        GrossReq: array[52] of Decimal;
        PeriodLength: DateFormula;
        Print: Boolean;
        i: Integer;
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PlannedReceipt: Decimal;
        PlannedRelease: Decimal;
        UseStockkeepingUnit: Boolean;
        SKUPrintLoop: Integer;
        ShippingTime: DateFormula;
        InventoryAvailabilityPlanCaptionLbl: Label 'Inventory - Availability Plan';
        CurrReportPageNoCaptionLbl: Label 'Page';
        GrossReq1CaptionLbl: Label '...Before';
        GrossReq8CaptionLbl: Label 'After...';
        VendorCaptionLbl: Label 'Vendor';
        GrossRequirementCaptionLbl: Label 'Gross Requirement';
        ScheduledReceiptCaptionLbl: Label 'Scheduled Receipt';
        InventoryCaptionLbl: Label 'Inventory';
        PlannedReceiptCaptionLbl: Label 'Planned Receipt';
        PlannedReleasesCaptionLbl: Label 'Planned Releases';
        LocationCaptionLbl: Label 'Location';
        ShippingTimeCaptionLbl: Label 'Shipping Time';
        PrePO: array[52] of Decimal;
        Forecast: array[52] of Decimal;
        Shipment: array[52] of Decimal;
        GrossPrePO: Decimal;
        GrossForecast: Decimal;
        GrossShipment: Decimal;
        PartsNoCaptionLbl: Label 'Product No.';
        CustItemNoCaptionLbl: Label 'Customer P/N';
        SalesOrderCaptionLbl: Label 'Sales Order';
        PurchOrderCaptionLbl: Label 'Purchase Order';
        PrePOCaptionLbl: Label 'Pre PO';
        ForecastCaptionLbl: Label 'Forecast';
        ShipmentCaptionLbl: Label 'Shipment';
        ExpectedReceiptDateFlag: array[52] of Integer;
        POShowStar: Boolean;

    procedure InitializeRequest(NewPeriodStartDate: Date; NewPeriodLength: DateFormula; NewUseStockkeepingUnit: Boolean)
    begin
        PeriodStartDate[2] := NewPeriodStartDate;
        PeriodLength := NewPeriodLength;
        UseStockkeepingUnit := NewUseStockkeepingUnit;
    end;
}

