pageextension 50020 GeneralLedgerEntriesExt extends "General Ledger Entries"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Document Date"; Rec."Document Date")
            {
            }
        }
    }

    trigger OnOpenPage()
    var
    begin

        //ToDo 
        //Table "User Group Member" is removed, this customization should be achieved other way. 
        /*
        //v20210301 Start
        UserGroupMember.RESET;
        UserGroupMember.SETFILTER("User Group Code",'%1|%2|%3','ACCOUNTING','OFFICE MANAGER','SYSTEM ADMIN');
        UserGroupMember.SETFILTER("User Security ID",USERSECURITYID);
        UserGroupMember.SETFILTER("Company Name",'%1|%2',COMPANYNAME,'');
        IF NOT UserGroupMember.FIND('-') THEN
          ERROR(Text000);
        //v20210301 End
        */

    end;

}