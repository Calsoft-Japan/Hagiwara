page 50122 "Hagiwara Approver E-Signature"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    PageType = List;
    SourceTable = "Hagiwara Approver E-Signature";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = all;
                }
                field("E-Signature"; Rec."E-Signature")
                {
                    ApplicationArea = all;
                }
            }
        }
    }


    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import signature';
                Image = Import;

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                    InStr: InStream;
                    TenantMedia: Record "Tenant Media";
                begin

                    if Rec."Sign Picture".HasValue() then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    ClientFileName := '';
                    UploadIntoStream(SelectPictureTxt, '', '', ClientFileName, InStr);
                    if ClientFileName <> '' then
                        FileName := FileManagement.GetFileName(ClientFileName);
                    //FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        Error('');

                    Clear(Rec."Sign Picture");
                    Rec."Sign Picture".ImportStream(InStr, FileName);
                    //Picture.ImportFile(FileName, ClientFileName);
                    if not Rec.Modify(true) then
                        Rec.Insert(true);

                    if TenantMedia.Get(Rec."Sign Picture".MediaId) then begin
                        TenantMedia.CalcFields(Content);
                        Rec."E-Signature" := TenantMedia.Content;
                        Rec.Modify(true);
                    end;

                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete Signature';
                Enabled = DeleteExportEnabled;
                Image = Delete;

                trigger OnAction()
                begin
                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec."Sign Picture");
                    Rec.Modify(true);

                    if Rec."E-Signature".HasValue then begin
                        Rec.CalcFields("E-Signature");
                        Clear(Rec."E-Signature");
                        Rec.Modify(true);
                    end;
                end;
            }
            action("Refresh Signature")
            {
                Image = Signature;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                begin
                    if Rec.FindSet() then
                        repeat
                            if TenantMedia.Get(Rec."Sign Picture".MediaId) then begin
                                TenantMedia.CalcFields(Content);
                                Rec."E-Signature" := TenantMedia.Content;
                                Rec.Modify(true);
                            end else begin
                                if Rec."E-Signature".HasValue then begin
                                    Rec.CalcFields("E-Signature");
                                    Clear(Rec."E-Signature");
                                    Rec.Modify(true);
                                end;
                            end;
                        until Rec.Next() = 0;

                    Rec.FindFirst();
                end;
            }
        }
    }

    var
        DeleteExportEnabled: Boolean;
        OverrideImageQst: Label 'The existing signature will be replaced. Do you want to continue?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteImageQst: Label 'Are you sure you want to delete the signature?';

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions();
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec."Sign Picture".HasValue;
    end;
}

